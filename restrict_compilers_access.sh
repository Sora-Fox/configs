#!/bin/bash

manual_compilers=(
    /usr/bin/gcc
    /usr/bin/g++
    /usr/bin/clang
    /usr/bin/clang++
    /usr/bin/make
    /usr/bin/python
    /usr/bin/python3
    /usr/bin/perl
    /usr/bin/ghc  # Haskell compiler
    /usr/bin/erlang
    /usr/bin/rustc
    /usr/bin/go
    /usr/bin/javac
    #/usr/bin/node
    /usr/bin/protoc  # Protocol Buffers compiler
    /usr/bin/flatc  # Flatbuffers compiler
    /usr/bin/orc  # Orc compiler
    /usr/bin/swiftc  # Swift compiler
    /usr/bin/dmd  # D compiler
    /usr/bin/fpc  # Free Pascal compiler
    /usr/bin/tcc  # Tiny C Compiler
    /usr/bin/v  # V language compiler
    /usr/bin/zig  # Zig compiler
    /usr/bin/gfortran  # Fortran compiler
    /usr/bin/icc  # Intel C Compiler
    /usr/bin/icpc  # Intel C++ Compiler
    /usr/bin/nasm  # Assembler
    /usr/bin/yasm  # Yet another assembler
)

restrict_compiler() {
    if [ -f "$1" ]; then
        echo "Restricting access to $1"
        sudo chmod o-rx "$1"  # Remove execute rights for other 
        sudo chmod g-rx "$1"  # Remove execute rights for groups
    fi
}

restore_compiler() {
    if [ -f "$1" ]; then
        echo "Restoring access to $1"
        sudo chmod o+rx "$1"
        sudo chmod g+rx "$1"
    fi
}

is_compiler() {
    local prog_name=$(basename "$1")
    if [[ "$prog_name" =~ ^(gcc|g\+\+|clang|clang\+\+|make|python[23]?|perl|ghc|erlang|rustc|go|javac|protoc|flatc|orc|swiftc|dmd|fpc|tcc|v|zig|gfortran|icc|icpc|nasm|yasm)$ ]]; then
        return 0
    else
        return 1
    fi
}

auto_find_compilers() {
    found_compilers=(
        $(which gcc g++ clang clang++ make python perl ghc erlang rustc go javac protoc flatc orc swiftc dmd fpc tcc v zig gfortran icc icpc nasm yasm 2>/dev/null)
    )

    valid_manual_compilers=()
    for compiler in "${manual_compilers[@]}"; do
        if [ -f "$compiler" ]; then
            valid_manual_compilers+=("$compiler")
        fi
    done

    all_compilers=("${valid_manual_compilers[@]}" "${found_compilers[@]}")
    filtered_compilers=()
    for compiler in "${all_compilers[@]}"; do
        if is_compiler "$compiler"; then
            filtered_compilers+=("$compiler")
        fi
    done
    filtered_compilers=($(echo "${filtered_compilers[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

    echo "${filtered_compilers[@]}"
}

echo -e "0 - Restrict (default)\n1 - Restore\nq - Exit"
while true ; do
    echo -n "Choose option: "
    read action
    if [ -z "$action" ]; then
        action=0
    fi
    if [ "$action" == "q" ]; then
        exit 0;
    elif [[ "$action" =~ ^[0-1]$ ]]; then 
        compilers=($(auto_find_compilers))
        echo "——————— Found and listed $((${#compilers[@]})) compilers ———————"
        if [ "$action" -eq 0 ]; then
            for compiler in "${compilers[@]}"; do
                restrict_compiler "$compiler"
            done
            echo "Access to compilers has been restricted."
            exit 0;
        elif [ "$action" -eq 1 ]; then
            for compiler in "${compilers[@]}"; do
                restore_compiler "$compiler"
            done
            echo "Access to compilers has been restored."
            exit 0;
        fi
    else
        echo -n "No such option! "
    fi
done


