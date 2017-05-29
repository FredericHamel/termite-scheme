#!/bin/sh

output=()
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

c_compile() {
  for i in ${obj[@]}; do
    echo "Compiling object $i"
    tsic $i
    if (( $? != 0 )); then
      exit 1
    fi
  done
  for i in "${exe[@]}"; do
    echo "Compiling executable $i"
    tsic -exe $i
    if (( $? != 0 )); then
      exit 1
    fi
  done
}

c_add_all() {
  c_obj data-server-common.scm
  c_exe data-server.scm
  c_exe client-3002.scm
  c_exe client-3003.scm
}

if (( $# == 0 )); then
  c_add_all
  c_clean
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
