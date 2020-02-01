import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:rundown_flutter/models/rundown_detail.dart';
import 'package:rundown_flutter/utils/utils.dart';

class RundownDetailComponent extends StatelessWidget {
  RundownDetail rundownDetail;

  RundownDetailComponent({Key key, @required this.rundownDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6),
      child: ClayContainer(
          borderRadius: 10,
          color: Utils.backgroundColor,
          child: InkWell(
            onTap: () {
              print(rundownDetail.title);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    rundownDetail.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      rundownDetail.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
