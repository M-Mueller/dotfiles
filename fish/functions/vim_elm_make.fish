function vim_elm_make
    elm make --report=json --output=/dev/null src/Main.elm &| jq -j '.errors[] as $e | ($e.problems[] | $e.path, ":", .region.start.line, ":", .region.start.column,  " (", $e.name , ") ", .title, "\n")'
end
