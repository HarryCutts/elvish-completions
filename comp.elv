use github.com/zzamboni/elvish-modules/util

fn decorate [&code-suffix='' &display-suffix='' &suffix='' &style='' @input]{
  if (eq (count $input) 0) {
    input = [(all)]
  }
  if (not-eq $suffix '') {
    display-suffix = $suffix
    code-suffix = $suffix
  }
  each [k]{
    edit:complex-candidate &code-suffix=$code-suffix &display-suffix=$display-suffix &style=$style $k
  } $input
}

fn expand-completion-item [def item]{
  if (has-key $def $item) {
    what = (kind-of $def[$item])
    if (eq $what 'fn') {
      $def[$item]
    } elif (eq $what 'list') {
      explode $def[$item]
    }
  }
}

fn sequence [def @cmd]{
  n = (count $cmd)
  expand-completion-item $def (util:min (- $n 2) (- (count $def) 1))
}

fn subcommands [def @cmd]{
  n = (count $cmd)

if (eq $n 2) {
  keys (dissoc $def -opts)
  if (has-key $def -opts) {
    expand-completion-item $def -opts
  }

} else {
    subcommand = $cmd[1]
    if (has-key $def $subcommand) {
      if (eq (kind-of $def[$subcommand]) 'string') {
        subcommands $def $cmd[0] $def[$subcommand] (explode $cmd[2:])
      } else {
        sequence $def[$subcommand] (explode $cmd[1:])
      }
    }
  }
}
