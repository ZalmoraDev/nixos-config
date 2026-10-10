#  **Understand the Configuration Format:**:
  
   The configuration file is a JSON object that contains a list of keys. Each key specifies:
     
   - ##**`color`**:  
   The color to apply (hex code, e.g., `"#FF0000"` for red).
     
   - ##**`shortcut`**:  
   The keyboard shortcut to trigger the action (e.g., `"Ctrl+R"`).
     
   - ##**`type`**:  
   The type of action (`"Foreground"` for text color, `"Background"` for highlighting).  

#  **Example configuration:**  

       "keys": [  
           ["#FF0000", "Ctrl+R", "Foreground"],  // Red text  
           ["#FFFF00", "Ctrl+H", "Background"],  // Yellow highlight  
           ["#00FF00", "Ctrl+G", "Background"],  // Green highlight  
           ["#0000FF", "Ctrl+B", "Foreground"]   // Blue text  
       ]  
