class FriendListInfo{
  final String userName;
  String profilePhoto;
  String LastMessage;
  bool isOnline;

  FriendListInfo({this.userName, this.profilePhoto,this.LastMessage,this.isOnline});

}

class GroupListInfo{
  final String groupName;
  String profilePhoto;
  String groupDesc;


  GroupListInfo({this.groupDesc,this.profilePhoto,this.groupName});
}