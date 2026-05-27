def frm [dir: path] {
  let targets = ls $dir | get name | input list -f -m
  if ($targets == null or ($targets | is-empty)) { return "No file or directory has been deleted." }
  $targets | each { rm -r $in }

  print "Removed the following files/directories:\n"
  return ($targets | to text)
}
