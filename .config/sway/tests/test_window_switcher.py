"""Regression tests: python3 -m unittest discover -s tests -v."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'scripts/window-switcher.sh'
STUB = '''#!/usr/bin/env python3
import os, pathlib, sys
base = pathlib.Path(os.environ['TEST_DIR'])
if pathlib.Path(sys.argv[0]).name == 'swaymsg':
    print((base / 'tree.json').read_text())
else:
    (base / 'menu').write_bytes(sys.stdin.buffer.read())
    sys.exit(1)  # Cancel: never focus a real window during the test.
'''


class WindowIconTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.apps = self.base / 'applications'
        self.apps.mkdir()
        for command in ('swaymsg', 'fuzzel'):
            path = self.base / command
            path.write_text(STUB)
            path.chmod(0o755)

    def menu_icon(self, app):
        tree = {'type': 'workspace', 'name': '1', 'focus': [10], 'floating_nodes': [],
                'nodes': [{'type': 'con', 'id': 10, 'pid': 100, 'focused': True,
                           'app_id': app, 'name': 'Test window', 'nodes': [], 'floating_nodes': []}]}
        (self.base / 'tree.json').write_text(json.dumps(tree))
        result = subprocess.run(['bash', str(SCRIPT)], capture_output=True, text=True,
                                env={**os.environ, 'TEST_DIR': str(self.base),
                                     'PATH': f"{self.base}:{os.environ['PATH']}",
                                     'XDG_DATA_HOME': str(self.base)})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, '')
        return (self.base / 'menu').read_bytes().split(b'\0icon\x1f', 1)[1].rstrip(b'\n').decode()

    def test_window_class_uses_desktop_icon_not_app_id(self):
        # Same mismatch as DataGrip: the window class is not an icon name.
        (self.apps / 'test-datagrip.desktop').write_text(
            '[Desktop Entry]\nType=Application\nName=DataGrip\nExec=datagrip\n'
            'StartupWMClass=jetbrains-datagrip\nIcon=/test/datagrip.png\n')
        self.assertEqual(self.menu_icon('jetbrains-datagrip'), '/test/datagrip.png')

    def test_unknown_application_keeps_icon_name_fallback(self):
        self.assertEqual(self.menu_icon('Test-Unknown-App'), 'test-unknown-app')

    def test_desktop_without_icon_keeps_fallback(self):
        (self.apps / 'test-no-icon.desktop').write_text(
            '[Desktop Entry]\nType=Application\nName=Test\nExec=test\n'
            'StartupWMClass=Test-No-Icon\n')
        self.assertEqual(self.menu_icon('Test-No-Icon'), 'test-no-icon')


if __name__ == '__main__':
    unittest.main()
