import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../size_config.dart';
import '../../models/task.dart';
import '../themes.dart';



class TaskTile extends StatelessWidget {
  const TaskTile(this.task,{super.key});

  final Task task;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(SizeConfig.orientation == Orientation.landscape ? 4 : 20),
      ),
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      width: SizeConfig.orientation == Orientation.landscape ? SizeConfig.screenWidth / 2 : SizeConfig.screenWidth,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(task.title!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${task.startTime!} - ${task.endTime}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(task.note!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(quarterTurns: 3,
            child: Text(task.isCompleted == 0? 'TODO': 'Completed',
                style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                ),
               ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch(color)
    {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
