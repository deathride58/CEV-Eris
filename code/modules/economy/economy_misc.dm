
#define RIOTS 1
#define WILD_ANIMAL_ATTACK 2
#define INDUSTRIAL_ACCIDENT 3
#define BIOHAZARD_OUTBREAK 4
#define WARSHIPS_ARRIVE 5
#define PIRATES 6
#define CORPORATE_ATTACK 7
#define ALIEN_RAIDERS 8
#define AI_LIBERATION 9
#define MOURNING 10
#define CULT_CELL_REVEALED 11
#define SECURITY_BREACH 12
#define ANIMAL_RIGHTS_RAID 13
#define FESTIVAL 14

#define RESEARCH_BREAKTHROUGH 15
#define BARGAINS 16
#define SONG_DEBUT 17
#define MOVIE_RELEASE 18
#define BIG_GAME_HUNTERS 19
#define ELECTION 20
#define GOSSIP 21
#define TOURISM 22
#define CELEBRITY_DEATH 23
#define RESIGNATION 24

#define DEFAULT 1

#define ADMINISTRATIVE 2
#define CLOTHING 3
#define SECURITY 4
#define SPECIAL_SECURITY 5

#define FOOD 6
#define ANIMALS 7

#define MINERALS 8

#define EMERGENCY 9
#define GAS 10
#define MAINTENANCE 11
#define ELECTRICAL 12
#define ROBOTICS 13
#define BIOMEDICAL 14

#define GEAR_EVA 15


// TODO: make niggas poor after implementation
/var/list/economic_species_modifier = list(/datum/species/human	= 10)

var/global/datum/money_account/vendor_account
var/global/datum/money_account/station_account
var/global/list/datum/money_account/department_accounts = list()
var/global/num_financial_terminals = 1
var/global/next_account_number = 0
var/global/list/all_money_accounts = list()

/proc/setup_economy()
	news_network.CreateFeedChannel("Nyx Daily", "SolGov Minister of Information", 1, 1)
	news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	create_station_account()

	for(var/department in station_departments)
		create_department_account(department)
	create_department_account("Vendor")
	vendor_account = department_accounts["Vendor"]


/proc/create_station_account()
	if(!station_account)
		next_account_number = rand(111111, 999999)

		station_account = new()
		station_account.owner_name = "[station_name()] Station Account"
		station_account.account_number = rand(111111, 999999)
		station_account.remote_access_pin = rand(1111, 111111)
		station_account.money = 75000

		//create an entry in the account transaction log for when it was created
		var/datum/transaction/T = new()
		T.target_name = station_account.owner_name
		T.purpose = "Account creation"
		T.amount = 75000
		T.date = "2nd April, 2555"
		T.time = "11:24"
		T.source_terminal = "Biesel GalaxyNet Terminal #277"

		//add the account
		station_account.transaction_log.Add(T)
		all_money_accounts.Add(station_account)

/proc/create_department_account(department)
	next_account_number = rand(111111, 999999)

	var/datum/money_account/department_account = new()
	department_account.owner_name = "[department] Account"
	department_account.account_number = rand(111111, 999999)
	department_account.remote_access_pin = rand(1111, 111111)
	department_account.money = 5000

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = department_account.owner_name
	T.purpose = "Account creation"
	T.amount = department_account.money
	T.date = "2nd April, 2555"
	T.time = "11:24"
	T.source_terminal = "Biesel GalaxyNet Terminal #277"

	//add the account
	department_account.transaction_log.Add(T)
	all_money_accounts.Add(department_account)

	department_accounts[department] = department_account
