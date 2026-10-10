from collections import defaultdict
from typing import Callable, List, Tuple

from aqt import gui_hooks, mw
from aqt.editor import Editor

# Load the addon's configuration
config = mw.addonManager.getConfig(__name__)

# Dictionary to group multiple actions for the same shortcut
shortcut_actions = defaultdict(list)

def apply_style(editor: Editor, colour: str, style_type: str) -> None:
    """
    Apply the specified style to the selected text in the editor.

    :param editor: The Editor instance.
    :param colour: The color to apply (hex code or color name).
    :param style_type: Either "Foreground" for text color or "Background" for highlight.
    """
    if style_type == "Foreground":
        editor.web.eval(f'document.execCommand("foreColor", false, "{colour}");')
    elif style_type == "Background":
        editor.web.eval(f'document.execCommand("hiliteColor", false, "{colour}");')
    else:
        raise ValueError(f"Invalid style type: {style_type}")

def execute_actions(editor: Editor, actions: List[Callable]) -> None:
    """
    Executes all actions associated with a single shortcut.

    :param editor: The Editor instance.
    :param actions: List of functions to execute.
    """
    for action in actions:
        action()

def on_setup_shortcuts(cuts: List[Tuple[str, Callable]], editor: Editor) -> None:
    """
    Add keyboard shortcuts to the editor for text color and highlighting.

    :param cuts: The list of shortcuts.
    :param editor: The Editor instance.
    """
    # Reset shortcut_actions to avoid duplicate assignments across multiple hooks
    shortcut_actions.clear()

    # Group actions by their shortcut key
    for colour, key, style_type in config["keys"]:
        shortcut_actions[key].append(lambda c=colour, t=style_type: apply_style(editor, c, t))

    # Add a combined callable for each shortcut key
    for key, actions in shortcut_actions.items():
        cuts.append((key, lambda a=actions: execute_actions(editor, a)))

# Hook into Anki to extend editor shortcuts
gui_hooks.editor_did_init_shortcuts.append(on_setup_shortcuts)
