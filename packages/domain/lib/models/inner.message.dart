enum InnerMessageType{ ERROR, TIP, MESSAGE }

class InnerMessage{
  InnerMessageType type;
  String message;
  InnerMessage({required this.message, required this.type});
}