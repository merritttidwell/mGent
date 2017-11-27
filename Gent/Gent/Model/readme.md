update firebase database rules to be as following, this will protect email duplications

{
"rules": {
".read": "auth != null",
".write": "auth != null",

"users": {
"$uid": {
".write": "auth !== null && auth.uid === $uid",
".read": "auth !== null && auth.provider === 'password'",
"username": {
".validate": "
!root.child('usernames').child(newData.val()).exists() ||
root.child('usernames').child(newData.val()).val() == $uid"
}
}
}
}
}
