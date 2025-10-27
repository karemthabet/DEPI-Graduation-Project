import 'package:flutter/material.dart';
import 'package:whatsapp/features/visit_Screen/view/visit_view.dart';
import '../widgets/favourite_card.dart';
class FavouriteView extends StatefulWidget {

   FavouriteView({ Key? key  }) : super(key: key);

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {


         final  placeCard =FavouriteCard();

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VisitedView()),
          );
        }
      }, 
    child :Scaffold(
      appBar: AppBar(
        title:  Text('favourite', 
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF243E4B)
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF243E4B)),
            onPressed: () {
              // Add search functionality here
            },
          ),
          
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        
      ),
      body:  Center(
         child: ListView.separated(
          itemCount:10 ,
          separatorBuilder: (BuildContext context, int index) {
            return placeCard;
          },
          itemBuilder: (BuildContext context, int index) {
            return placeCard;
          }
        )
        ),
      )
    );
  }
}
