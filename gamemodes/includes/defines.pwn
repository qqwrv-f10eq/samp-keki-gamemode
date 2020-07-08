//--------------------------------[DEFINES.PWN]--------------------------------

// ใช้มาโคร BitFlag
#define bf_get(%0,%1)            ((%0) & (%1))   // ส่งค่ากลับ 0 (เท็จ)หากยังไม่ได้ตั้งค่าให้มัน
#define bf_on(%0,%1)             ((%0) |= (%1))  // ปรับค่าเป็น เปิด
#define bf_off(%0,%1)            ((%0) &= ~(%1)) // ปรับค่าเป็น ปิด
#define bf_toggle(%0,%1)         ((%0) ^= (%1))  // สลับค่า (สลับ จริง/เท็จ)

// ใช้มาโคร Key
#define Pressed(%0)	\
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define Holding(%0) \
	((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// Weapon Skill
#define NORMAL_SKILL		1
#define MEDIUM_SKILL		2
#define FULL_SKILL			3

#define WEAPON_UNARMED 		0
#define WEAPON_PISTOLWHIP 	48
#define WEAPON_CARPARK 		52

#define MAX_DAMAGES			30 // Damage System

#define	MAX_FACTIONS		20
#define MAX_FACTION_RANKS	21
#define MAX_FACTION_SKINS	20
#define MAX_FACTION_WEAPONS	10

// MYSQL UPDATE
#define MYSQLUPDATE_TYPE_SINGLE	0
#define MYSQLUPDATE_TYPE_THREAD	1

// BODY PARTS
#define BODY_PART_TORSO 	3
#define BODY_PART_GROIN 	4
#define BODY_PART_RIGHT_ARM 5
#define BODY_PART_LEFT_ARM 	6
#define BODY_PART_RIGHT_LEG 7
#define BODY_PART_LEFT_LEG 	8
#define BODY_PART_HEAD 		9

// Spawn points:
#define SPAWN_POINT_DEFAULT		(0)
#define SPAWN_POINT_PROPERTY	(1)
#define SPAWN_POINT_FACTION		(2)

#define MAX_STRING	255