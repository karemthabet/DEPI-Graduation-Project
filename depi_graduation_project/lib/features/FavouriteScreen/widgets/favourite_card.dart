 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whatsapp/core/functions/device_size.dart';
import 'package:whatsapp/core/utils/colors/app_colors.dart';
class FavouriteCard extends StatefulWidget {
    FavouriteCard ({ Key? key})  : super(key: key);

  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return  Container(

      width: screenWidth(context)*.37,
      height: screenHeight(context)*.14,
decoration: BoxDecoration(
 
  color:AppColors.Cardcolor,
  borderRadius: BorderRadius.circular(16.0),

    
    ),
  
margin: EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 8.0,
  ),
padding: EdgeInsets.symmetric(
  horizontal: 8.0,
  vertical: 16.0
),

  child: Row( 
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.end,   
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:
                  Image.asset(
                    
                    'assets/images/place1.png',
                    width: 119,
                    height: 100,
                    fit: BoxFit.cover,
                    
                  ),),
                ),
                SizedBox(width: 16),
       
         
          Column(
              
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('place name' , 
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF243E4B)
                  ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.namesColor,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'giza, Egypt,near the pyramids',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.namesColor
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.starColor,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.namesColor
                        ),
                      ),
                    ],
                  ),
                
                    ],
                  ),
       
       
        Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             IconButton(onPressed:(){
                          setState(() {
                            isFavorite = !isFavorite;
                          });
             } , icon:Icon(

                           isFavorite? Icons.favorite : Icons.favorite_border,
                           color: isFavorite ? Colors.red : Colors.grey,
                          size: 14,
                        ), ),
           ],
         ),
       
                  
       
                ],
              ),
              
            

      );
    
  }
}