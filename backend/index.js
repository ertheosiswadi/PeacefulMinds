const express = require('express');
const app = express();
var path = require('path');

const PORT = process.env.PORT || 3000

app.use(express.static('./public'));

app.get('', (request, response)=>{
	response.send('this is the homepage, it does nothing');
})

app.get('/:username/:procedure/:hospital', (request, response)=> {
	var u = request.params.username;
	var p = request.params.procedure;
	var h = request.params.hospital;
	generateHospitalTable(u, p, h).then((result)=>{
		response.send(result);
	});	
});

app.get('/:username/:procedure', (request, response)=> {
	var u = request.params.username;
	var p = request.params.procedure;
	generateAllTables(u, p).then((result)=>{
		response.send(result);
	});	
});

//this really is actually a post lol
app.get('/add_user/:username/:password/:zipcode/:insurance_id/:insurance_provider',(request,response)=>{
	var u = request.params.username;
	var p = request.params.password;
	var z = parseInt(request.params.zipcode);
	var iid = request.params.insurance_id;
	var ip = request.params.insurance_provider;
	addUser(u,p,z,iid,ip).then(()=>{
		response.send(u + ' account created')
	})
});


app.listen(PORT, ()=> {
	console.log('server is live');
});

var firebase = require('firebase-admin');
var serviceAccount = require('/home/esiswadi/Documents/fir-auth-test-private-key.json');

firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
  databaseURL: "https://fir-auth-test-d5364.firebaseio.com"
});

const settings = {/* your settings... */ timestampsInSnapshots: true};
firebase.firestore().settings(settings);

const db = firebase.firestore();

const userref = db.collection('users');

// ----------------- Get user information from username -------

async function getUser(username)
{
	var toReturn = false;
	await userref.where('username', '==', username).get().then((snap) => {
		if(!snap.empty)
		{
			userdoc = snap.docs[0];
			user = userdoc.data();
			var ip = user.insurance_provider;
			var iid = user.insurance_id;
			var zipcode = user.zipcode;
			var deductible = user.deductible;
			var user = {
				username: username,
				insurance_id: iid,
				insurance_provider: ip,
				zipcode: zipcode,
				insurance_plan: whichInsurancePlan(iid),
				deductible: deductible
			};
			toReturn = user;
		}
		else{
			console.log('user dun exist');
		}
	});
	return toReturn;
}

// getUser('ertheosiswaadi').then((result) => {
// 	if(result != false)
// 	{
// 		//do something with the result json data
// 	}
// });
// ---------------- Adding User Feature --------------------

// addUser('ertheosiswadi', 'pokoroyo123' ,90025, 'WABC3100', 'ip_1');

async function addUser(username, password, zipcode, iid, ip){
	var user = {
		insurance_id : iid,
		insurance_provider : ip,
		username: username,
		password: password,
		zipcode: zipcode,
		deductible: Math.round(Math.random() * (100 - 15) + 15) //this amount is determined by the generator Math.random() * (max - min) + min
	};

	doesUsernameExist(username).then((val) => {
		if(val == true)
		{
			console.log('username exists');
		}
		else
		{
			userref.add(user).then(() => {
				console.log('user account: ' + username + ' created');
			});			
		}
	});
}

async function doesUsernameExist(username){
	var toReturn = false;
	await userref.get().then((snap) => {
		snap.forEach((doc) => {
			var json_data = doc.data();
			var uname = json_data.username;

			if(username == uname)
			{
				toReturn =  true;
			}
		});
	});
	return toReturn;
}

function whichInsurancePlan(iid){
	var identifier = iid.charAt(iid.length-1); //if last char is 0 plan 1, otherwise plan 2
	if(identifier == '0')
	{
		return 'plan_1'
	}
	else{
		return 'plan_2'
	}
}

async function isHospitalInNetwork(hospital, ip){ //compare the hospital name against an in network list get using the ip	
	var toReturn = false;
	await getListOfInNetworkHospitals(ip).then((list)=>{
		for(var key in list)
		{
			if(hospital == list[key])
			{
				toReturn = true;
			}
		};
	});
	return toReturn
}

async function getListOfInNetworkHospitals(ip){
	var toReturn;
	await db.collection('insurance_providers').doc(ip).collection('in_hospitals').doc('in_hospitals').get().then((doc)=>{
		var list = doc.data();
		toReturn = list;
	});
	return toReturn;
}

// isHospitalInNetwork('hospital_1', 'ip_2').then((result) => {
// 	console.log(result);
// })

async function getServicesForProcedure(hospital, procedure){ //returns a json of services for the procedure

	var toReturn
	await db.collection('hospital').doc(hospital).collection('procedures').doc(procedure).get().then((doc) => {
		var list = doc.data();
		toReturn = list['service'];
	});
	return toReturn;
}

async function getAllInsuranceAdjustments(i_plan, ip){ //insurance adjustments list
	var toReturn;
	await db.collection('insurance_providers').doc(ip).collection('plans').doc(i_plan).get().then((doc) => {
		toReturn = doc.data();
	})
	return toReturn;
}

async function getInsuranceCoverage(i_plan, ip){
	var toReturn;
	await db.collection('insurance_providers').doc(ip).collection('coverage').doc(i_plan).get().then((doc) => {
		toReturn = doc.data()['coverage'];
	})
	return toReturn;
}

function calcualteAdj(cost, percentage){
	return (cost * percentage)/100;
}

function getPostAdj(cost, adj)
{
	return cost - adj;
}

async function generateAllTables(username, procedure){
	var toReturn = [];
	var h_name;
	var result;
	var i = 0;
	for(i = 0; i < 10; i++)
	{
		h_name = 'hospital_' + i;
		await generateHospitalTable(username, procedure, h_name).then((result)=>{
			// console.log('result-> ' + result + ' <-')
			toReturn.push(result);
		})
		// console.log('im here')
	}
	return toReturn;
}

async function getOONFEE(hospital)
{
	var toReturn;
	await db.collection('hospital').doc(hospital).get().then((doc)=> {
		var data = doc.data();
		toReturn = data['OON_fee'];
	})
	return toReturn;
}


async function generateHospitalTable(username, procedure, hospital)
{
	var services, user;
	var insurance_adjs;
	var coverage;
	var table_1 = [];
	var isInNetwork;
	var OON_fee;

	await getUser(username).then((data) => {
		user = data;
	})
	await getServicesForProcedure(hospital, procedure).then((data)=> {
		services = data;
	});
	await getAllInsuranceAdjustments(user.insurance_plan, user.insurance_provider).then((data)=>{
		insurance_adjs = data;
	});
	await getOONFEE(hospital).then((data)=>{
		OON_fee = data;
	})
	await isHospitalInNetwork(hospital, user.insurance_provider).then((data)=>{
		isInNetwork = data;
	})	
	await getInsuranceCoverage(user.insurance_plan, user.insurance_provider).then((data)=>{
		coverage = data;
		coverage = OONFilter(isInNetwork, OON_fee, coverage);
	});

	// console.log(user);
	// console.log(isInNetwork);

	//create table_1 part1
	for(i in services)
	{
		var s = services[i];
		var adj_percent = insurance_adjs[i]['coverage']
		adj_percent = OONFilter(isInNetwork, OON_fee, adj_percent);
		s['i_adj'] = calcualteAdj(s['price'], adj_percent);
		s['post_adj'] = getPostAdj(s['price'], s['i_adj']);
		table_1.push(s);
	}

	//create table_2 part2
	var table_2={};
	var total_post_adj = 0;

	table_1.forEach((row) => {
		total_post_adj += row['post_adj'];
	})
	// console.log(total_post_adj);
	var deductible = user.deductible;
	// console.log('deduct-> ' + deductible);
	var total_owe;
	var isDeductibleLessThan = false;
	if(deductible <= total_post_adj)
	{
		total_owe = deductible + ((total_post_adj - deductible) * coverage)/100
		isDeductibleLessThan = true;
	}
	else
	{
		total_owe = total_post_adj;
	}
	table_2['total_post_adj'] = total_post_adj;
	table_2['deductible'] = deductible;
	table_2['insurance_coverage'] = coverage + '%';
	table_2['isDeductibleLessThan'] = isDeductibleLessThan;
	table_2['total_owe'] = total_owe;
	table_2['isInNetwork'] = isInNetwork;

	var toReturn = {
		part1: table_1,
		part_2: table_2
	}
	return toReturn;
}

// generateHospitalTable('ertheosiswadi', 'procedure_1', 'hospital_0').then((result)=>{
// 	console.log(result);
// })
// generateAllTables('ertheosiswadi', 'procedure_1').then((result)=>{
// 	console.log(result);
// });	

function OONFilter(isInNetwork, OONFee, cost)
{
	if(!isInNetwork)
	{
		return ((100-OONFee)*cost)/100
	}
	return cost;
}