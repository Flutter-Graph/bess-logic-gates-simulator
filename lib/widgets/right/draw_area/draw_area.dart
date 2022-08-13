import 'package:bess/data/draw_area/draw_area_data.dart';
import 'package:bess/data/draw_area/objects/draw_objects.dart';
import 'package:bess/data/draw_area/objects/io/obj_input_button.dart';
import 'package:bess/data/draw_area/objects/pins/obj_pin.dart';
import 'package:bess/data/draw_area/objects/wires/obj_wire.dart';
import 'package:bess/data/mouse_data.dart';
import 'package:bess/themes.dart';

import './drawer/draw_input_button.dart';
import './drawer/draw_nand_gate.dart';
import './drawer/draw_nor_gate.dart';
import './drawer/draw_wire.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class DrawArea extends StatefulWidget {
  const DrawArea({Key? key}) : super(key: key);

  @override
  State<DrawArea> createState() => _DrawAreaState();
}

class _DrawAreaState extends State<DrawArea>
    with AutomaticKeepAliveClientMixin<DrawArea> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  void onDrawAreaClick(DrawAreaData data) {
    data.setSelectedItemId("");
  }

  @override
  Widget build(BuildContext context) {
    final drawAreaData = Provider.of<DrawAreaData>(context);
    final mouseData = Provider.of<MouseData>(context, listen: false);
    super.build(context);
    return GestureDetector(
      onTap: () {
        onDrawAreaClick(drawAreaData);
      },
      child: InteractiveViewer(
        maxScale: 4.0,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                MyTheme.backgroundColor,
                BlendMode.colorBurn,
              ),
              image: const AssetImage("assets/images/grid.png"),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: MouseRegion(
            onHover: (e) {
              mouseData.setMousePos(e.localPosition);
            },
            child: Stack(
              children: [
                ...List.generate(
                  drawAreaData.objects.length,
                  (index) {
                    if (index >= drawAreaData.objects.length) {
                      return const SizedBox(width: 0, height: 0);
                    }

                    var item = drawAreaData.objects.values.elementAt(index);
                    if (item.type == DrawObject.nandGate) {
                      return DrawNandGate(
                        id: item.id,
                        initialPos: const Offset(100.0, 100.0),
                      );
                    } else if (item.type == DrawObject.norGate) {
                      return DrawNorGate(
                        id: item.id,
                        initPos: const Offset(100.0, 100.0),
                      );
                    } else if (item.type == DrawObject.wire) {
                      var item_ = item as DAOWire;

                      if (drawAreaData.objects[item_.startPinId] == null ||
                          drawAreaData.objects[item_.endPinId] == null) {
                        drawAreaData.objects.remove(item.id);
                        return const SizedBox();
                      }

                      var sPin =
                          drawAreaData.objects[item_.startPinId] as DrawAreaPin;
                      var ePin =
                          drawAreaData.objects[item_.endPinId] as DrawAreaPin;

                      return DrawWire(
                        id: item_.id,
                        endPos: ePin.pos!,
                        startPos: sPin.pos!,
                      );
                    } else if (item.type == DrawObject.inputButton) {
                      var item_ = item as DAOInputButton;
                      return DrawInputButton(
                        id: item_.id,
                        pinId: item_.pinId,
                      );
                    } else {
                      return const SizedBox(width: 0, height: 0);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
