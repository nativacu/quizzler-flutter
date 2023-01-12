import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = new QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Icon correctAnswerIcon = Icon(Icons.check, color: Colors.green);
  Icon wrongAnswerIcon = Icon(Icons.close, color: Colors.red);

  List<Icon> answers = [];

  Icon getAnswerIcon(bool response) {
    return response == quizBrain.getQuestionAnswer()
        ? correctAnswerIcon
        : wrongAnswerIcon;
  }

  void restartGame() {
    quizBrain.restartIndex();
    answers = [];
  }

  void displayGameOverAlert() {
    int correctAnswerCount =
        answers.where((element) => element == correctAnswerIcon).length;
    int totalQuestions = quizBrain.getQuestionAmount();
    Alert(
      context: context,
      title: "GAME OVER",
      desc: "Got $correctAnswerCount correct out of $totalQuestions",
      buttons: [
        DialogButton(
          child: Text(
            "Restart",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {
            setState(() {
              restartGame();
              Navigator.pop(context);
            })
          },
          color: Colors.blueAccent,
        )
      ],
    ).show();
  }

  void updateAnswers(bool response) {
    if (quizBrain.hasNextQuestion()) {
      answers.add(getAnswerIcon(response));
      quizBrain.nextQuestion();
    } else {
      this.displayGameOverAlert();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  updateAnswers(true);
                });
                //The user picked true.
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  updateAnswers(false);
                });
                //The user picked false.
              },
            ),
          ),
        ),
        Wrap(
          children: answers,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
