extends Node


const AP_COST_VISIT_CONCERT = 5
const AP_COST_NEGOTIATION = 3
const AP_COST_COMPOSE = 10
const AP_COST_SELF_TRAINING = 10
const AP_COST_TRAINING = 1
const AP_COST_JOB = 1
const AP_COST_BANK = 3
const AP_COST_LOG_HIRE = 5
const AP_COST_PLAN_SELF = 10

const male_name = ["Liam", "Noah", "William", "James", "Oliver", "Benjamin", "Elijah", "Lucas", "Mason", "Logan", "Alexander", "Ethan", "Jacob", "Michael", "Daniel", "Henry", "Jackson", "Sebastian", "Aiden", "Matthew", "Samuel", "David", "Joseph", "Carter", "Owen", "Wyatt", "John", "Jack", "Luke", "Jayden", "Dylan", "Grayson", "Levi", "Isaac", "Gabriel", "Julian", "Mateo", "Anthony", "Jaxon", "Lincoln", "Joshua", "Christopher", "Andrew", "Theodore", "Caleb", "Ryan", "Asher", "Nathan", "Thomas", "Leo", "Isaiah", "Charles", "Josiah", "Hudson", "Christian", "Hunter", "Connor", "Eli", "Ezra", "Aaron", "Landon", "Adrian", "Jonathan", "Nolan", "Jeremiah", "Easton", "Elias", "Colton", "Cameron", "Carson", "Robert", "Angel", "Maverick", "Nicholas", "Dominic", "Jaxson", "Greyson", "Adam", "Ian", "Austin", "Santiago", "Jordan", "Cooper", "Brayden", "Roman", "Evan", "Ezekiel", "Xavier", "Jose", "Jace", "Jameson", "Leonardo", "Bryson", "Axel", "Everett", "Parker", "Kayden", "Miles", "Sawyer", "Jason"]
const female_name = ["Emma", "Olivia", "Ava", "Isabella", "Sophia", "Charlotte", "Mia", "Amelia", "Harper", "Evelyn", "Abigail", "Emily", "Elizabeth", "Mila", "Ella", "Avery", "Sofia", "Camila", "Aria", "Scarlett", "Victoria", "Madison", "Luna", "Grace", "Chloe", "Penelope", "Layla", "Riley", "Zoey", "Nora", "Lily", "Eleanor", "Hannah", "Lillian", "Addison", "Aubrey", "Ellie", "Stella", "Natalie", "Zoe", "Leah", "Hazel", "Violet", "Aurora", "Savannah", "Audrey", "Brooklyn", "Bella", "Claire", "Skylar", "Lucy", "Paisley", "Everly", "Anna", "Caroline", "Nova", "Genesis", "Emilia", "Kennedy", "Samantha", "Maya", "Willow", "Kinsley", "Naomi", "Aaliyah", "Elena", "Sarah", "Ariana", "Allison", "Gabriella", "Alice", "Madelyn", "Cora", "Ruby", "Eva", "Serenity", "Autumn", "Adeline", "Hailey", "Gianna", "Valentina", "Isla", "Eliana", "Quinn", "Nevaeh", "Ivy", "Sadie", "Piper", "Lydia", "Alexa", "Josephine", "Emery", "Julia", "Delilah", "Arianna", "Vivian", "Kaylee", "Sophie", "Brielle", "Madeline"]
const surname = ["Smith", "Hall", "Stewart", "Price", "Johnson", "Allen", "Sanchez", "Bennett", "Williams", "Young", "Morris", "Wood", "Jones", "Hernandez", "Rogers", "Barnes", "Brown", "King", "Reed", "Ross", "Davis", "Wright", "Cook", "Henderson", "Miller", "Lopez", "Morgan", "Coleman", "Wilson", "Hill", "Bell", "Jenkins", "Moore", "Scott", "Murphy", "Perry", "Taylor", "Green", "Bailey", "Powell", "Anderson", "Adams", "Rivera", "Long", "Thomas", "Baker", "Cooper", "Patterson", "Jackson", "Gonzalez", "Richardson", "Hughes", "White", "Nelson", "Cox", "Flores", "Harris", "Carter", "Howard", "Washington", "Martin", "Mitchell", "Ward", "Butler", "Thompson", "Perez", "Torres", "Sommons", "Garcia", "Roberts", ]

const labelNames = ["Overtown Records", "Capital Records", "Mutown Records"]

var diary = []

func generateNameAndGender():
	randomize()
	var rand = randi() % 2
	var fname = randi() % male_name.size()
	var rsurname = randi() % surname.size()
	var gGender = ""
	var gName = ""

	if rand == 0:
		gGender = "w"
		gName = female_name[fname] + " " + surname[rsurname]
	else:
		gGender = "m"
		gName = male_name[fname] + " " + surname[rsurname]

	return {"name": gName, "gender": gGender }

func shortName(fullname):
	var data = fullname.split(" ")
	return data[0].substr(0,1) + ". " + data[1]

func calculateSalary(talent):
	var salaray = talent.character.charisma * talent.character.popularity * 3 + talent.character.motivation * talent.character.talent * talent.character.skills.singer * 4
	return salaray
	
	
