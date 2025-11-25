import 'package:flutter/material.dart';
import 'package:tst_flutter/widgets/counter_widget.dart';

class HomePageColumn extends StatelessWidget {
  const HomePageColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Image.network(
            "https://media.istockphoto.com/id/1399246824/fr/photo/digital-eye-wave-lines-stock-background.jpg?s=612x612&w=0&k=20&c=vzYCTiu1RWxQdqBl1lzKUaDs1oW-zzNQI7kiAVrd4xI=",
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: Image.asset("images/profile.png"),
        ),
        CounterWidget(),
      ],
    );
  }
}
