import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'items_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var player=AudioCache();
  List<ItemsModel>? items;
  List<ItemsModel>? items2;
  late int score;
  bool? gameOver;

  initGame() {
    score = 0;
    gameOver = false;
    items = [
      ItemsModel(
          name: 'Camel', value: 'Camel', image: 'assets/images/camel.png'),
      ItemsModel(name: 'Cat', value: 'Cat', image: 'assets/images/cat.png'),
      ItemsModel(name: 'Cow', value: 'Cow', image: 'assets/images/cow.png'),
      ItemsModel(name: 'Dog', value: 'Dog', image: 'assets/images/dog.png'),
      ItemsModel(name: 'Fox', value: 'Fox', image: 'assets/images/fox.png'),
      ItemsModel(name: 'Hen', value: 'Hen', image: 'assets/images/hen.png'),
      ItemsModel(
          name: 'Horse', value: 'Horse', image: 'assets/images/horse.png'),
      ItemsModel(name: 'Lion', value: 'Lion', image: 'assets/images/lion.png'),
      ItemsModel(
          name: 'Panda', value: 'Panda', image: 'assets/images/panda.png'),
      ItemsModel(
          name: 'Sheep', value: 'Sheep', image: 'assets/images/sheep.png'),
    ];
    items2 = List<ItemsModel>.from(
        items!); //بدل لما اكتب ال name value تاني وهكذا بقوله ساويها بالlistالاولي
    items!.shuffle(); // هنا بيقولك كل مره هيتم ترتيبها عشوائي بين ال Items
    items2!.shuffle(); // هنا بيقولك كل مره اختار عشوائي بين ال Items
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items!.length == 0) gameOver = true;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'Score: ',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: '$score',
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.teal),
                    ),
                  ]),
                ),
              ),
              if (gameOver == false)
                Row(
                  children: [
                    Spacer(),
                    Column(
                      children: items!.map((item) {
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Draggable<ItemsModel>(
                            data: item,
                            child: CircleAvatar(
                              backgroundImage: AssetImage('${item.image}'),
                              backgroundColor: Colors.white,
                              radius: 30,
                            ),
                            feedback: CircleAvatar(
                              backgroundImage: AssetImage('${item.image}'),
                              backgroundColor: Colors.white,
                              radius: 30,
                            ),
                            childWhenDragging: CircleAvatar(
                              backgroundImage: AssetImage('${item.image}'),
                              backgroundColor: Colors.white,
                              radius: 50,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Column(
                        children: items2!.map((item) {
                      return DragTarget<ItemsModel>(
                        onAccept: (receivedItem) {
                          if (item.value == receivedItem.value) {
                            setState(() {
                              items!.remove(receivedItem);
                              items2!.remove(item);
                            });
                            score += 10;
                            item.accepting = false;
                            player.play('assets/audioo/true.wav');
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepting = false;
                            });
                          }
                        },
                        onWillAccept: (receivedItem) {
                          setState(() {
                            item.accepting = true;
                          });
                          return true;
                        },
                        onLeave: (receivedItem) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        builder: (context, acceptedItems, rejectedItems) =>
                            Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: item.accepting
                                ? Colors.grey[400]
                                : Colors.grey[200],
                          ),
                          height: MediaQuery.of(context).size.width / 6.5,
                          width: MediaQuery.of(context).size.width / 3,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(9),
                          child: Text(
                            '${item.name}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                      );
                    }).toList()),
                    Spacer(),
                  ],
                ),
              if (gameOver == true)
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'GameOver',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            result(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                        TextButton(
                            onPressed: (){
                              setState(() {
                                initGame();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.width/10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.teal,
                              ),
                                child: Text('New Game',style: TextStyle(color: Colors.white),)
                            )
                        ),
                      ],
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  String result() {
    if (score == 100) {
      return 'congratulation'.toUpperCase();
    } else {
      return 'Play Again To Get Better Score'.toUpperCase();
    }
  }
}
