const randomInt = require('random-int');
const randomWord = require('random-word');
const randomDate = require('random-datetime');
const pg = require('phrase-generator');
const uuidV1 = require('uuid/v1');
var randomItem = require('random-item');
var Identity = require('fake-identity');

const array = n => new Array(n).fill(null)
const collection = n => cb => array(n).map((_, i) => cb(i))
const randomId = top => randomInt(top - 1)
const randomBool = _ => !randomInt(1)
const randomLevel = _ => randomItem(['begginer', 'intermediate', 'advanced']);

const ORGANIZATIONS = 2
const COMPETITORS = ORGANIZATIONS * 50
const COMPETITIONS = 2
const EVENTS = 2
const ROUNDS = 2
const JUDGES = 10
const PARTNERSHIPS = COMPETITORS // 2x more than needed just in case
const ADMINS = 5
const PAYMENTS = COMPETITORS

let prevdata = null
const randomData = refresh => {
  if (refresh || !prevdata) prevdata = Identity.generate()
  return prevdata
}

const get_competitors = n => collection(n)(i => ({
  "id" : i,
  "First Name" : randomData(1).firstName,
  "Last Name" : randomData().lastName,
  "Email Address" :  randomData().emailAddress,
  "Mailing Address" : randomData().street,
  "Lead Number" : randomBool() ? randomInt(0, 100) : null,
  "Competitor Organization id" : randomId(ORGANIZATIONS),
  "Password" : uuidV1(),
  "Registered?" : randomBool(),
}))

// So its not completley RNG
const get_callbacks = competitors => competitors
.filter(c => c["Lead Number"])
.map((c, i) => ({
  "id" : i,
  "Timestamp" : randomDate({year: 2017}),
  "Judge id" : randomId(JUDGES),
  "Lead Competitor number" : c["Lead Number"],
  "Round id" : randomId(ROUNDS),
}))


const get_competitions = n => collection(n)(i => ({
  "id" : i,
  "Name" : randomWord(),
  "leadIdStartNum" : 0, // TODO
  "LocationName" : randomData(1).city,
  "EarlyPrice" : randomInt(0, 100),
  "RegPrice" : randomInt(0, 100),
  "LatePrice" : randomInt(0, 100),
  "StartDate" : randomDate({year: 2018}),
  "EndDate" : randomDate({year: 2018}),
  "RegStartDate" : randomDate({year: 2017}),
  "RegEndDate" : randomDate({year: 2017}),
  "EarlyRegDeadline" : randomDate({year: 2017}),
  "RegularRegDeadline" : randomDate({year: 2017}),
}))


const get_events = n => collection(n)(i => ({
  "id" : i,
  "competitionId" : randomId(COMPETITIONS),
  "Title" : pg.generate(),
  "Style" : pg.generate(),
  "Level" : randomLevel(),
}))

const get_rounds = n => collection(n)(i => ({
  "id" : i,
  "Event" : randomId(EVENTS),
  "Name" : pg.generate(),
  "Order number" : i,
  "Size" : randomInt(50, 100),
  "nextRound" : randomInt(0, 20),
}))

const get_partnerships = n => collection(n)(i => ({
  "Lead Competitor id" : randomId(COMPETITORS),
  "Follow Competitor id" : randomId(COMPETITORS),
  "Event Category" : 0, // TODO
  "Lead Confirmed" : randomBool(),
  "Follow Confirmed" : randomBool(),
}))

const get_organizations = n => collection(n)(i => ({
  "id" : i,
  "name" : randomData(1).company,
}))

const get_admins = n => collection(n)(i => ({
  "Username" : randomData(1).emailAddress,
  "Password" : uuidV1(),
}))

const get_judges = n => collection(n)(i => ({
  "id" : i,
  "Email address" : randomData(1).emailAddress,
  "Token" : uuidV1(),
  "First Name" : randomData().firstName,
  "Last Name" : randomData().lastName,
  "Current event id" : randomId(EVENTS)
}))

const get_payment_records = n => collection(n)(i => ({
  "id" : i,
  "competitionId" : randomId(COMPETITIONS),
  "Timestamp" : randomDate({year: 2017}),
  "Competitor id" : randomId(COMPETITORS),
  "Amount" : randomInt(50, 100)/2,
  "Online/offline" : randomBool(),
  "Payer name" : randomData(1).firstName + ' ' + randomData(1).lastName,
}))


const competitors = get_competitors(COMPETITORS)
const competitions = get_competitions(COMPETITIONS)
const events = get_events(EVENTS)
const rounds = get_rounds(ROUNDS)
const partnerships = get_partnerships(PARTNERSHIPS)
const organizations = get_organizations(ORGANIZATIONS)
const payment_records = get_payment_records(PAYMENTS)
const callbacks = get_callbacks(competitors)
const admins = get_admins(ADMINS)
const judges = get_judges(JUDGES)


module.exports = {
  competitors,
  competitions,
  events,
  rounds,
  partnerships,
  organizations,
  payment_records,
  callbacks,
  admins,
  judges,
}

