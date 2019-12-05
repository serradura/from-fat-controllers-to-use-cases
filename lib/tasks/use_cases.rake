desc 'Prints the number of lines of .rb files which contains a Micro::Case class'
task :use_cases do
  system(<<~SHELL)
    cd #{Rails.root.to_s}  \
    && printf 'Lines:\\n' \
    && grep --include *.rb -REl '(<\s*Micro::Case|(include.*)?Micro::Case::Flow\\(?)' . \
    | xargs wc -l  \
    | tee /dev/tty \
    | wc -l        \
    | awk '{printf "\\nFiles: %s\\n",$1-1}'
  SHELL
end
