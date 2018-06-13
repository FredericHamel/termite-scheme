#!/bin/sh

num_proc=$(nproc)
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
  exit 0
}

c_compile() {
  local cpt
  local out
  local fd
  cpt=0
  for fd in ${obj[@]}; do
    out=${fd%.*}.o1
    if (( cpt >= $num_proc )); then
      wait
      (( cpt = 0 ))
    fi 

    c_compile_file "Compiling object $fd" $fd $out &
    (( cpt += 1 ))
  done
  for i in "${exe[@]}"; do
    out=${i%.*}
    if (( cpt >= $num_proc )); then
      wait
      (( cpt = 0 ))
    fi 
    c_compile_file "Compiling executable $i" $i $out -exe &
    (( cpt += 1 ))
  done

  # Wait for all build to end.
  wait
}

c_add_all() {
  if [ -r $PWD/config.cfg ]; then
    source "$PWD/config.cfg"
  else
    echo "config.cfg not found..."
  fi
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
