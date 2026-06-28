INSERT INTO USERS.USERS
(Full_Name, User_Name, Password, Role)
VALUES
(N'محمد ناصر', 'm.nasser', '123', N'مدير النظام'),

(N'يوسف أحمد', 'y.ahmed', '456', N'موظف إدخال بيانات'),

(N'أحمد عبدالرحمن', 'a.abdelrahman', '789', N'موظف إدخال بيانات'),

(N'منة فؤاد', 'm.fouad', '000', N'مشاهد');


INSERT INTO REFERENCE.ROAD_USER_TYPE
(Type_Name)
VALUES
(N'سائق'),
(N'راكب'),
(N'مشاة'),
(N'راكب خارج المركبة');