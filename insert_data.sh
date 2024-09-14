#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

# read the games.csv file using cat and apply a while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # if first line then skip
  if [[ $YEAR != "year" ]]
  then

    # get winner team id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
    # if winner team id is null
    if [[ -z $WINNER_TEAM_ID ]]
    then
      INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER into teams table
        WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
      fi
    fi

    # get opponent team id
    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
    # if winner team id is null
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT into teams table
        OPPONENT_TEAM_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
      fi
    fi

    # insert data into games table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted game $YEAR $ROUND $WINNER $OPPONENT into the games table
    fi
  fi
done