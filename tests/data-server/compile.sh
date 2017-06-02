#!/bin/sh

output=(_termite.log)
exe=()
obj=()

c_exe () {
  if (( $# == 1 )); then
    output[${#output[@]}]=${1%.*}
    exe[${#exe[@]}]=$1
  fi
}

c_obj () {
  if (( $# == 1 )); then
    output[${#output[@]}]=${1%.*}.o1
    obj[${#obj[@]}]=$1
  fi
}

c_clean() {
  if (( ${#output[@]} > 0 )); then
    for i in "${output[@]}"; do
      if [[ -r $i ]]; then
        echo "Cleaning $i"
        rm  $i
      fi
    done
  fi
}

c_compile_file() {
  if (( $# >= 3 )); then
    if [[ -r $3 ]]; then
      local in_modify_time=`stat -c %Y $2`
      local out_modify_time=`stat -c %Y $3`
      if (( $in_modify_time > $out_modify_time )); then
        echo $1
        rm $3
        tsic $4 $2
      fi
    else
      echo $1
      tsic $4 $2
    fi
  fi
}

c_compile() {
  for i in ${obj[@]}; do
    out=${i%.*}.o1
    c_compile_file "Compiling object $i" $i $out
    if (( $? != 0 )); then
      exit 1
    fi
  done
  for i in "${exe[@]}"; do
    out=${i%.*}
    c_compile_file "Compiling executable $i" $i $out -exe
    if (( $? != 0 )); then
      exit 1
    fi
  done
  unset out
  unset i
}

c_add_all() {
  c_obj data-server-common.scm
  c_exe data-server.scm
  c_exe client-3002.scm
  c_exe client-3003.scm
}

c_clean

if (( $# == 0 )); then
  c_add_all
  c_compile
else
  case $1 in
    -c)
      c_add_all
      c_clean
      ;;
    -e)
      if (( $# == 2 )); then
        c_exe $2
        c_compile
      else
        echo "Invalid number of arguments $#"
      fi
      ;;
    -o)
      if (( $# == 2 )); then
        c_obj $2
        c_clean
        c_compile
      else
        echo "Invalid number of arguments $#"
      fi
      ;;
    *)
      echo "Invalid argument $1"
      ;;
  esac
fi
