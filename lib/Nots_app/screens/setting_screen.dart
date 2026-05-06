import 'package:flutter/material.dart';
import '../models/login_models.dart';
import '../service/Login_Service.dart';

class SettingScreen extends StatefulWidget {
  final LoginModels user;

  const SettingScreen({super.key, required this.user});



  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {




  Future<void> updateLogin() async {
    final updated = LoginModels(
      id: widget.user.id,
      email: widget.user.email,
      password: widget.user.password,
    );

    await LoginService().updateLogin(updated);

    Navigator.pop(context, updated);
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Settings',
          style: TextStyle(
          ),
        ),
      ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(height: 10,),


            Center(
              child: Container(
                height: 90,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),

                  ]
                ),

                child: Column(
                  children: [
                    SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 7,),
                        Text('Email :',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(width: 12,),
                        Text( '${widget.user.email}',style: TextStyle(
                          fontSize: 20,
                        ),),
                        SizedBox(height: 20,),

                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Text('Note :',style: TextStyle(
                          fontSize: 20,

                        ),),
                        SizedBox(width: 12,),
                        Text('10',style: TextStyle(
                          fontSize: 20,
                        ),),
                        SizedBox(width: 90,),
                        Text('Favorite :',style: TextStyle(
                          fontSize: 20,

                        ),),
                        SizedBox(width: 12,),
                        Text('10',style: TextStyle(
                          fontSize: 20,
                        ),),
                        SizedBox(height: 20,),




                      ],
                    ),
                  ],
                ),



                        ),
            ),

          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Account',style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
              fontWeight: FontWeight.bold
            ),),
          ),
          SizedBox(height: 10,),
        Center(
          child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),

                  ]
              ),
            child: Column(
              children: [
                SizedBox(height: 10,),

                
              ]


            ),
          ),
        )
        ]

      )
    );
  }
}
