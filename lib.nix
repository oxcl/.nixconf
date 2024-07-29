{
  enablePrograms = list: let attrList = map (program: { name = program; value = { enable = true}; }) list in listToAttrs attrList;
}
