#!/usr/bin/env bash

#  ╺┳┓┏━┓╻ ╻┏┓╻╻  ┏━┓┏━┓╺┳┓   ┏━╸╻ ╻╻┏┓ ╻  ╻   ┏━┓┏━┓╺┳╸╻ ╻┏━┓┏━┓╻┏
#   ┃┃┃ ┃┃╻┃┃┗┫┃  ┃ ┃┣━┫ ┃┃   ┃╺┓┣━┫┃┣┻┓┃  ┃   ┣━┫┣┳┛ ┃ ┃╻┃┃ ┃┣┳┛┣┻┓
#  ╺┻┛┗━┛┗┻┛╹ ╹┗━╸┗━┛╹ ╹╺┻┛   ┗━┛╹ ╹╹┗━┛┗━╸╹   ╹ ╹╹┗╸ ╹ ┗┻┛┗━┛╹┗╸╹ ╹
# List of works available at: https://www.ghibli.jp/works

declare -A movies

movies[baron]="The Cat Returns"
movies[chihiro]="Spirited Away"
movies[ged]="Tales from Earthsea"
movies[howl]="Howls Moving Castle"
movies[kaguyahime]="The Tale of The Princess Kaguya"
movies[karigurashi]="Arrietty"
movies[kazetachinu]="The Wind Rises"
movies[kokurikozaka]="From Up on Poppy Hill"
movies[laputa]="Castle in the Sky"
movies[majo]="Kikis Delivery Service"
movies[marnie]="When Marnie Was There"
movies[mimi]="Whisper of the Heart"
movies[mononoke]="Princess Mononoke"
movies[nausicaa]="Nausicaä of the Valley of the Wind"
movies[omoide]="Only Yesterday"
movies[ponyo]="Ponyo on the Cliff by the Sea"
movies[porco]="Porco Rosso"
movies[redturtle]="The Red Turtle"
movies[tanuki]="Pom Poko"
movies[totoro]="My Neighbor Totoro"

tmp_directory=$(mktemp -d)

function sanitize_movie_name() {
  lowercased=${1,,}
  no_whitespace=${lowercased// /-}

  echo "$no_whitespace"
}

for movie_id in "${!movies[@]}"; do
  movie_name=${movies[$movie_id]}
  movie_directory=$(sanitize_movie_name "$movie_name")
  download_count=0

  mkdir -p "$tmp_directory/$movie_directory"

  for ((idx = 1; idx <= 50; idx++)); do
    if [[ idx -lt 10 ]]; then
      file_name="00$idx"
    else
      file_name="0$idx"
    fi

    curl --fail -o "$tmp_directory/$movie_directory/$file_name.jpg" \
      "https://www.ghibli.jp/gallery/$movie_id$file_name.jpg" &> /dev/null || break
    download_count="$idx"
  done

  echo "🎥 $movie_name: downloaded $download_count images."
done

xdg-open "$tmp_directory"
