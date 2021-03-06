/* 
 * EVENT REGISTRATION
 *
 * This page will be used by users to register for events in a 
 * specific selected competition
 */

import style from "./style.css"
import React from 'react'
import EventTable from './common/EventTable.jsx'
import Autocomplete from 'react-autocomplete'
import Page from './Page.jsx'
import { RadioGroup, Radio } from 'react-radio-group'
import Box from './common/Box.jsx'
import { Link } from 'react-router'
import cloneDeep from 'lodash/cloneDeep';
import findIndex from 'lodash/findIndex';

// competition/:competition_id/eventregistration
export default class PageEventRegistration extends React.Component {


  constructor(props) {
    super(props)
    this.state = {
      /** We will populate this w/ data from the API */
      competition: null,
      competition_events: [],
      user_competition_events: [],
      competitors: [],
      levels: [],
      level_styles: [],
      level_style_events: [],

      value: '',
      loading: false,
      partner: null,

      // Selected stuff
      levelid: null,
      styleid: null,
      eventid: null,
      isLeading: null,
    }

    /** Take the competition ID from the URL (Router hands
    it to us; see the path for this Page on Router) and make
    sure it's an integer */
    try {
      // this.competition_id = this.props.selected.competition.id
      this.competition_id = this.props.params.competition_id
      this.competitor_id = this.props.profile.competitor_id 
    }
    catch (e) { alert('Invalid competition ID!') }
  }
  componentDidMount(){
    /* Call the API for competition data */
    this.props.api.get(`/api/competition/${this.competition_id}`)
      .then(json => { 
        // update the state of our component
        this.setState({ competition : json })
      })
      // todo; display a nice (sorry, there's no connection!) error
      // and setup a timer to retry. Fingers crossed, hopefully the 
      // connection comes back
      .catch(err => console.error(err))

    /** Pretty similar to above! */
    this.props.api.get(`/api/competition/${this.competition_id}/events`)
      .then(json => {
        this.setState({ competition_events : json})
      })
      .catch(err => console.error(err))

    this.props.api.get(`/api/competitors/${this.competitor_id}/${this.competition_id}/events`)
      .then(json => {
        console.log(json)
        for (let i = 0; i < json.length; i++) {
          json[i].title = json[i].dance;
          if (json[i].leadcompetitorid == this.competitor_id) {
            json[i].leader = "You"
            json[i].follower = json[i].followfirstname+" "+json[i].followlastname
          } else {
            json[i].follower = "You"
            json[i].leader = json[i].leadfirstname+" "+json[i].leadlastname
          }
        }
        this.setState({user_competition_events: json})
      })
      .catch(err => { console.error(err)})

    /** Fetch levels in a competition */
    this.props.api.get(`/api/competition/${this.competition_id}/levels`)
      .then(json => {

        this.setState({levels: json})
      })
      .catch(err => console.error(err))

    /** Fetch competitors for partner search */
    this.props.api.get(`/api/competitors`)
      .then(json => {
        json = json.filter(item => {
          return item.id != this.competitor_id
        })
        this.setState({competitors: json})
      })
      .catch(err => console.error(err))
  }

  handleLevelChange = (levelid) => {
    fetch(`/api/competition/${this.competition_id}/level/${levelid}/styles`)
      .then(response => {
        return response.json()
      })
      .then(json => {
        this.setState({level_styles: json})
      })
      .catch(err => console.error(err))
      if ( this.state.styleid){
        fetch(`/api/competition/${this.competition_id}/level/${levelid}/style/${this.state.styleid}`)
        .then(response => {
          return response.json()
        })
        .then(json => {
          this.setState({level_style_events: json})
        })
        .catch(err => console.error(err))
      }
      this.setState({
          levelid: parseInt(levelid),
          eventid: null 
      });
  };

  handleStyleChange = (styleid) => {
    fetch(`/api/competition/${this.competition_id}/level/${this.state.levelid}/style/${styleid}`)
      .then(response => {
        return response.json()
      })
      .then(json => {
        this.setState({level_style_events: json})
      })
      .catch(err => console.error(err))
    this.setState({
        styleid: parseInt(styleid),
        eventid: null
    });
  };

  handleEventChange = (eventid) => {
    this.setState({
      eventid: parseInt(eventid)
    });
  };

  handleLeadChange = (isLeading) => {
      this.setState({isLeading});
  };

  checkIfNotExists = (reg) => {
      const { eventid } = this.state;
      return (reg["eventid"] != eventid);
  };

  registerEventHandler = () => {
      const { levelid, styleid, eventid, partner, isLeading, user_competition_events } = this.state;
      const button_enabled = (eventid != null) && (isLeading != null) && (partner != null)
      console.log(user_competition_events)
      console.log(eventid)
      if (button_enabled) {
          if (!user_competition_events.every(this.checkIfNotExists)) {
              console.log(user_competition_events.every(this.checkIfNotExists));
              alert('You are already registered for this event!');
              return false
          } else if (this.competitor_id == partner) {
              alert('This is a partner dance competition silly, dance with somebody else!');
              return false
          }
          var leadcompetitorid = partner;
          var followcompetitorid = this.competitor_id;
          if (isLeading == 'Leading') {
            leadcompetitorid = this.competitor_id;
            followcompetitorid = partner;
          }
            fetch("/api/create_partnership", {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    leadcompetitorid: leadcompetitorid,
                    followcompetitorid: followcompetitorid,
                    eventid: eventid,
                    competitionid: this.competition_id
                })
            }).then((response) => {
                fetch("/api/create_paymentrecord", {
                    method: 'POST',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                      competitionid: this.competition_id,
                      competitorid: leadcompetitorid,
                      amount: this.state.competition.regularprice,
                      online: false,
                      paidwithaffiliation: true,
                    })
                }).then((response) =>{
                    console.log(response)
                    fetch("/api/create_paymentrecord", {
                      method: 'POST',
                      headers: {
                          'Accept': 'application/json',
                          'Content-Type': 'application/json',
                      },
                      body: JSON.stringify({
                        competitionid: this.competition_id,
                        competitorid: followcompetitorid,
                        amount: this.state.competition.regularprice,
                        online: false,
                        paidwithaffiliation: true,
                      })
                  }).then((response) =>{
                    console.log(response)
                    window.location.reload();
                  })
                })
            });
      } else {
          alert('Please finish selecting a event and your partner!');
      }
  };

dropEventHandler = (rowData) => {
        const eventName = rowData.level + " " + rowData.style + " " + rowData.dance;
        const name = rowData.leader == "You" ? rowData.follower : rowData.leader;
        if (!confirm("Are you sure you want to drop " + eventName + " with " + name + "?")) {
            return false;
        }
        fetch("/api/delete_partnership", {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                leadcompetitorid: rowData.leadcompetitorid,
                followcompetitorid: rowData.followcompetitorid,
                eventid: rowData.eventid
            })
        }).then(() => {
            window.location.reload();
        });
  };
  
  render() {
    const search_competitor = (list, query) => {
    if (query === '') return []
    return list.filter(comp => 
        comp.email.indexOf(query) != -1 ||
        comp.firstname.toLowerCase().indexOf(query.toLowerCase()) != -1 ||
        comp.lastname.toLowerCase().indexOf(query.toLowerCase()) != -1
      )
    }

    const show_style = this.state.levelid !== null
    const show_event = this.state.styleid !== null
    const show_leading = this.state.eventid !== null

    const myMenuStyle = {
      borderRadius: '3px',
      boxShadow: '0 2px 12px rgba(0, 0, 0, 0.1)',
      background: 'rgba(255, 255, 255, 0.9)',
      padding: '2px 0',
      fontSize: '90%',
      overflow: 'auto',
      maxHeight: '50%', // TODO: don't cheat, let it flow to the bottom
      zIndex: 200
    };


    return (

    <Page ref="page" {...this.props}>
      <h1>Event Registration</h1>
        <Box 
        title = {<div>Register for New Event</div>}>
        <div className={style.lines}>
        { true && <span>
            <h2>Level</h2>
            <RadioGroup name='level' selectedValue={this.state.levelid && this.state.levelid.toString()} onChange={this.handleLevelChange}>
              {
                this.state.levels.map(item =>{
                  return (<div key={item.id}><Radio value={item.id.toString()}/>{item.name}</div>);
                })
              }
            </RadioGroup>
            <br/>
          </span>
        } 

        { show_style && <span>
            <br/>
            <h2>Style</h2>
            <RadioGroup name='style' selectedValue={this.state.styleid && this.state.styleid.toString()} onChange={this.handleStyleChange}>
              {
                this.state.level_styles.map(item =>{
                  return (<div key={item.id}><Radio value={item.id.toString()}/>{item.name}</div>);
                })
              }
            </RadioGroup>
            <br/>
          </span>
        }
        {<div>
          <br/>
        { show_event && <span>
            <h2>Event</h2>
            <RadioGroup name='event' selectedValue={this.state.eventid && this.state.eventid.toString()} onChange={this.handleEventChange}>
              {
                this.state.level_style_events.map(item =>{
                  return (<div key={item.id}><Radio value={item.id.toString()}/>{`${item.levelname} ${item.stylename} ${item.dance}`}</div>);
                })
              }
            </RadioGroup>
          </span>
        }
          <br/>
        </div>}

              { show_leading && <span>
                 <br/>
            <h3>Are you leading or following?</h3>
            <RadioGroup name='lead' selectedValue={this.state.isLeading} onChange={this.handleLeadChange}>
              <div><Radio value='Leading'/>Leading</div>
              <div><Radio value='Following'/>Following</div>
            </RadioGroup>
            <br/>
          </span>
              }
        <br/>
        <hr />
        <h2>Partner's email</h2>

        <Autocomplete
          menuStyle={myMenuStyle}
          inputProps={{name: "US state", id: "states-autocomplete"}}
          ref="autocomplete"
          value={this.state.value}
          items={this.state.competitors}
          getItemValue={(item) => item.email}
          onSelect={(value, item) => {
            // set the menu to only the selected item
            this.setState({ value, competitors: [ item ], partner: item.id })
            // or you could reset it to a default list again
            // this.setState({ unitedStates: getStates() })
              }}
          onChange={(event, value) => {
            this.setState({ value, loading: true })

            fetch(`/api/competitors`)
              .then(response => response.json())
              .then(json => {
                json = json.filter(item => {
                    return item.id != this.competitor_id
                })
                json = search_competitor(json, value)
                this.setState({competitors: json, loading: false})
              })
              .catch(err => console.error(err))
          }}
          renderItem={(item, isHighlighted) => (
            <div
              key={item.abbr}
              id={item.abbr}
            >{item.firstname} {item.lastname} ({item.email})</div>
          )}
        />
      <p><button onClick={this.registerEventHandler} className={style.registerBtn}>Register</button></p>
              </div>
      </Box>

      <Box title={<div>Your Current Registrations</div>}>
        <EventTable
          events={this.state.user_competition_events}
          extra_columns={[{
            content: (value, {rowData}) => (
              <div>
                <span
                  onClick={()=>this.dropEventHandler(rowData)}
                  style={{ marginLeft: '1em', cursor: 'pointer' }}
                >
                  &#10007; Drop
                </span>
              </div>
            )
          }]}
        />
      </Box>
     </Page>
   );
 }
}

