#!/bin/bash

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
VERSION="v0.2.0"

PETFILE="default"
COWFILE="./petfiles/default/default.cow"

cd "$SCRIPT_DIR"

help() {
  echo "TPet - A virtual pet inside your bash shell."
  echo ""
  echo "Usage: tpet [options]"
  echo ""
  echo "Options:"
  echo "-h, --help      Show this help message"
  echo "-v, --version   Show version information"
  echo "--scary-mode    (NOT YET IMPLEMENTED) Add some horror aspects to the game. WILL EDIT YOUR DOTFILES IN A REVERSIBLE WAY. If your dotfiles are managed through something like ml4w, scary mode is not reccommended, as it might cause damage to the integrity of your installation"
  echo "--petfile,-p    Select custom petfile (actually a directory but everything is a file on unix so I am factually correc)"
  exit 0
}

version() {
  echo "TPet version $VERSION"
  exit 0
}

for arg in "$@"; do 
  case $arg in 
    --help|-h)
      help
      ;;
    --version|-v)
      version
      ;;
    --petfile=*|-p=*)
      PETFILE="${arg#*=}"
      ;;
    --petfile|-p)
      shift
      PETFILE="$1"
      ;;
    --scary-mode)
      echo "Scary mode has not yet been added."
      exit 0
      ;;
  esac
done

# Verify Petfile
PETFILE_DIR="./petfiles/$PETFILE"
if [ ! -d "$PETFILE_DIR" ]; then
  echo "ERROR: Petfile '$PETFILE' not found!"
  exit 1
fi


# Variables
mood="playful"
hunger=5
fun=5
tiredness=5

dialogue_dir="./dialogue"

get_cowfile() {
  local cowfile_path="$PETFILE_DIR/$mood.cow"
  if [ -f "$cowfile_path" ]; then
    COWFILE="$cowfile_path"
  else
    COWFILE="$PETFILE_DIR/default.cow"
  fi
}

# Pick random dialogue 
random_line() {
  local file=$1
  if [ -f "$file" ]; then
    mapfile -t lines < "$file"
    line="${lines[$((RANDOM % ${#lines[@]}))]}"
    eval cowsay -f "$COWFILE" "$line"
  else
    echo "IDK what to say when I feel $mood, this is a debug message... Whatever that means" | cowsay -f "$COWFILE"
  fi
}

# Calculate the current mood
get_mood() {
  if [ $fun -lt 3 ] && [ $hunger -lt 5 ] && [ $tiredness -lt 5 ]; then
    echo "playful"
  elif [ $tiredness -ge 7 ] && [ $fun -ge 5 ]; then
    echo "sleepy"
  elif [ $hunger -ge 7 ] && [ $fun -ge 3 ]; then
    echo "hungry"
  elif [ $fun -ge 7 ] && [ $hunger -ge 4 ]; then
    echo "grumpy"
  else
    echo "neutral"
  fi
}

die() {
  clear
  cowsay -f "$COWFILE" $1
  sleep 1
  clear
  cowsay -f "$COWFILE" "bye..."
  sleep 1
}


# Main Loop
while true; do
  clear

  mood=$(get_mood)
  get_cowfile

  random_line "$dialogue_dir/$mood.txt"
  echo "Mood: $mood | Hunger: $hunger/10 | Fun: $((10 - fun))/10 | Tiredness: $tiredness/10"
  echo -e "\nCommands: [F]eed [P]lay [S]leep [Q]uit"
  
  # Input
  read -n 1 -t 3 action
  case $action in 
    f) 
      fun=$((fun + 1))
      hunger=$((hunger - 3))
      ;;
    p) 
      fun=$((fun - 3))
      hunger=$((hunger + 2))
      tiredness=$((tiredness + 3))
      ;;
    s)
      fun=$((fun + 3))
      hunger=$((hunger + 3))
      tiredness=$((tiredness - 8))
      echo "pet is sleeping. please be quiet for 5 seconds."
      sleep 5
      ;;
    q) 
      clear
      break
      ;;
  esac

  # Prevent scores from going out of bounds
  if [ $fun -gt 10 ]; then
    fun=10
    die "you aren't fun anymore..."
    break
  elif [ $fun -lt 0 ]; then
    fun=0
  fi

  if [ $tiredness -gt 10 ]; then
    tiredness=10
    die "I'll... *yawn*... go.. lay down..."
    break
  elif [ $tiredness -lt 0 ]; then
    tiredness=0
  fi

  if [ $hunger -gt 10 ]; then
    hunger=10
    die "s-.. so.. hungr-...."
    break
  elif [ $hunger -lt 0 ]; then
    hunger=0
  fi

done
