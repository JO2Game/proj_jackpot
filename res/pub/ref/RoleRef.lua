--create by xlsx2Lua.py 2016-01-07 14:46:42
GameRef = GameRef or {}
GameRef.RoleRef = {
[1001] = {refId=1001, name="role_name1", type=1, maxLevel=999999999, desc="role_desc1", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1002] = {refId=1002, name="role_name2", type=2, maxLevel=999999999, desc="role_desc2", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1003] = {refId=1003, name="role_name3", type=2, maxLevel=999999999, desc="role_desc3", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1004] = {refId=1004, name="role_name4", type=2, maxLevel=999999999, desc="role_desc4", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1005] = {refId=1005, name="role_name5", type=2, maxLevel=999999999, desc="role_desc5", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1006] = {refId=1006, name="role_name6", type=2, maxLevel=999999999, desc="role_desc6", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1007] = {refId=1007, name="role_name7", type=2, maxLevel=999999999, desc="role_desc7", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1008] = {refId=1008, name="role_name8", type=2, maxLevel=999999999, desc="role_desc8", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1009] = {refId=1009, name="role_name9", type=2, maxLevel=999999999, desc="role_desc9", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1010] = {refId=1010, name="role_name10", type=2, maxLevel=999999999, desc="role_desc10", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1011] = {refId=1011, name="role_name11", type=2, maxLevel=999999999, desc="role_desc11", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1012] = {refId=1012, name="role_name12", type=2, maxLevel=999999999, desc="role_desc12", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1013] = {refId=1013, name="role_name13", type=2, maxLevel=999999999, desc="role_desc13", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1014] = {refId=1014, name="role_name14", type=2, maxLevel=999999999, desc="role_desc14", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1015] = {refId=1015, name="role_name15", type=2, maxLevel=999999999, desc="role_desc15", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1016] = {refId=1016, name="role_name16", type=2, maxLevel=999999999, desc="role_desc16", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1017] = {refId=1017, name="role_name17", type=2, maxLevel=999999999, desc="role_desc17", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1018] = {refId=1018, name="role_name18", type=2, maxLevel=999999999, desc="role_desc18", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1019] = {refId=1019, name="role_name19", type=2, maxLevel=999999999, desc="role_desc19", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1020] = {refId=1020, name="role_name20", type=2, maxLevel=999999999, desc="role_desc20", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1021] = {refId=1021, name="role_name21", type=2, maxLevel=999999999, desc="role_desc21", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1022] = {refId=1022, name="role_name22", type=2, maxLevel=999999999, desc="role_desc22", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1023] = {refId=1023, name="role_name23", type=2, maxLevel=999999999, desc="role_desc23", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1024] = {refId=1024, name="role_name24", type=2, maxLevel=999999999, desc="role_desc24", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1025] = {refId=1025, name="role_name25", type=2, maxLevel=999999999, desc="role_desc25", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1026] = {refId=1026, name="role_name26", type=2, maxLevel=999999999, desc="role_desc26", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1027] = {refId=1027, name="role_name27", type=2, maxLevel=999999999, desc="role_desc27", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1028] = {refId=1028, name="role_name28", type=2, maxLevel=999999999, desc="role_desc28", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1029] = {refId=1029, name="role_name29", type=2, maxLevel=999999999, desc="role_desc29", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1030] = {refId=1030, name="role_name30", type=2, maxLevel=999999999, desc="role_desc30", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1031] = {refId=1031, name="role_name31", type=2, maxLevel=999999999, desc="role_desc31", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1032] = {refId=1032, name="role_name32", type=2, maxLevel=999999999, desc="role_desc32", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1033] = {refId=1033, name="role_name33", type=2, maxLevel=999999999, desc="role_desc33", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1034] = {refId=1034, name="role_name34", type=2, maxLevel=999999999, desc="role_desc34", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1035] = {refId=1035, name="role_name35", type=2, maxLevel=999999999, desc="role_desc35", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
[1036] = {refId=1036, name="role_name36", type=2, maxLevel=999999999, desc="role_desc36", img="role.png", att=6, def=3, hp=10, attPer=0.1, defPer=0.1, hpPer=0.1, skills="80001:10|80002:30", equips="60001:10|60002:30", },
};