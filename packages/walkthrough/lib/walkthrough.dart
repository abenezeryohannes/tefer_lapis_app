import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walkthrough/config/pelete.dart';
import 'package:walkthrough/widget/walk.dart';
import 'config/AppTheme.dart';
import 'domain/walkthrough_item.dart';
import 'package:rive/rive.dart';

class Walkthrough extends StatefulWidget {

  final List<WalkthroughItem> walkThroughItems;
  final ThemeData theme;
  final String Function(String) tr;
  final Function() onEnd;

  const Walkthrough({ Key? key, required this.walkThroughItems, required this.tr, required this.onEnd, required this.theme }) : super(key: key);

  @override
  _WalkthroughState createState() => _WalkthroughState();

}

class _WalkthroughState extends State<Walkthrough> {

  PageController controller = PageController(initialPage: 0);
  
  late Walk walks; 
  int _currentPosition = 0;
  
  int _validPosition(int position) {  return (position >= widget.walkThroughItems.length)? 0 : (position < 0)? widget.walkThroughItems.length-1: position;  }
 
  @override
  void initState() { 
    super.initState();
  }

  Widget _buildPageViews(int index){
    return walks.info(index);
  }
 
  @override
  Widget build(BuildContext context) {
    
    walks = Walk.initialize(walkthroughItems: widget.walkThroughItems, context: context, tr: widget.tr, theme: widget.theme);

    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      body: Stack(
        children: <Widget> [
          PageView.builder(
            controller: controller,
            onPageChanged: (index){onPageChange(index);},
            scrollDirection: Axis.horizontal,
            itemCount: widget.walkThroughItems.length,
            itemBuilder: (context, index){ 
              return _buildPageViews(index);
              }),
            

          
           Align(
            alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom:25), 
                        child: DotsIndicator(
                        dotsCount: widget.walkThroughItems.length,
                        position: double.parse(_validPosition(_currentPosition).toString()),
                        decorator: DotsDecorator(
                          color: widget.theme.dividerColor,
                          activeColor: widget.theme.colorScheme.secondary,
                        ),
                    ),
                      ),
           ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(bottom:10),
              padding: const EdgeInsets.only(left:10, right:10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: (_currentPosition==0?0:1),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.navigate_before, size: 24.0, color: widget.theme.dividerColor,),
                              Text( "Back", style: widget.theme.textTheme.bodyText1,),
                             ],
                          ),
                        ),
                        onTap: (){onBackPressed();},
                      ),
                    ),

                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              ( _currentPosition!= widget.walkThroughItems.length-1 )?"Next":"Start",
                              style:widget.theme.textTheme.bodyText1,
                            ), 
                            Icon(Icons.navigate_next, size: 24.0, color: widget.theme.dividerColor,)
                          ],
                        ),
                      ),
                      onTap: (){onNextPressed(widget.walkThroughItems);},
                    ),



                  ],
                ),
            ),
          ),



          Container(
              margin: const EdgeInsets.fromLTRB(0, 42, 20, 0),
              height: MediaQuery.of(context).size.height * 1 / 5,
              alignment: Alignment.topRight,
              child: const Hero(
                tag: 'kid',
                child: Material(
                    elevation: 8.0,
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: RiveAnimation.asset('assets/anim/lapis.riv',
                        alignment:Alignment.center,
                        fit:BoxFit.contain,
                        stateMachines: ['State Machine Idle'],
                        artboard: 'New Artboard',
                        animations: ['idle'],
                      ),
                      radius: 40,
                    )),
              )
          ),




          Padding(
            padding: const EdgeInsets.fromLTRB(0, 34, 0, 0),
            child:  Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  onPressed: () => { SystemNavigator.pop(animated: true) },
                  color: widget.theme.colorScheme.onBackground,
                  icon: const Icon(Icons.cancel, size: 28,),
                ),
            ),
          ),




        ]
      )
    );
  }


  void onBackPressed(){
      controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onPageChange(int index){
    setState(() { _currentPosition = index; });
  }


  void onNextPressed(List<WalkthroughItem> items ) async{
     
    if(_currentPosition != items.length-1) {
      controller.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }else {
      widget.onEnd();
    }
      
  }

}