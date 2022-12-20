#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE Table games, teams")

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do

#Update Teams Table

#use winner_team to insert first set of team name
Team_1=$($PSQL "select name from teams where name='$winner'")
if [[ $winner != "winner" ]]
  then
#if not found
  if [[ -z $Team_1 ]]
    then
#insert team name
    winner_team=$($PSQL "insert into teams(name) values ('$winner')")
    if [[ $winner_team == "INSERT 0 1" ]]
      then
      echo inserted into teams, $winner
    fi
  fi
fi    

#use opponent_team to insert  second set of team name
Team_2=$($PSQL "select name from teams where name='$opponent'")
if [[ $opponent != "opponent" ]]
  then
  if [[ -z $Team_2 ]]
    then
    opponent_team=$($PSQL "insert into teams(name) values ('$opponent')")
    if [[ $opponent_team == "INSERT 0 1" ]]
      then
      echo inserted into teams, $opponent
    fi
  fi
fi    

#Update Games Table
Team_Id_Winner=$($PSQL "select team_id from teams where name='$winner'")
Team_Id_Opponent=$($PSQL "select team_id from teams where name='$opponent'")

if [[ -n $Team_Id_Winner || -n $Team_Id_Opponent ]]
  then
    if [[ $year != "year" ]]
      then
      Game_ID=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ('$year', '$round',  '$Team_Id_Winner', '$Team_Id_Opponent', '$winner_goals', '$opponent_goals')")
        if
        [[ $Game_ID == "INSERT 0 1" ]]
          then 
          echo Inserted into database
        fi
    fi
fi
done
