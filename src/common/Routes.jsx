import React from 'react';
import { Route, IndexRoute } from 'react-router';
import App from './App';

import LoginPage            from '../PageLogin.jsx'
import HomePage             from '../PageHome.jsx'
import CompetitionListPage  from '../PageCompetitionList.jsx'
import CompetitionPage      from '../PageCompetition.jsx'
import EventRegistration    from '../PageEventRegistration.jsx'
import EditSchedule         from '../PageEditSchedule.jsx'
import RunCompetition       from '../PageRunCompetition.jsx'
import CompetitionHomeAdmin from '../PageCompetitionHomeAdmin.jsx'
import EditProfile          from '../PageEditProfile.jsx'

const routes = {
  'home'                                          : HomePage,
  'competition/:competition_id/eventregistration' : EventRegistration,
  'competition/:competition_id/editschedule'      : EditSchedule,
  'competition/:competition_id/run'               : RunCompetition,
  'competition/:competition_id/:competitor_id'    : CompetitionPage,
  'competitions'                                  : CompetitionListPage,
  'admin/competition/:competition_id'             : CompetitionHomeAdmin,
  'editprofile'                                   : EditProfile,
}

export default (
  <Route path="/" component={App}>
    <IndexRoute component={LoginPage} />
    { Object.keys(routes)
      .map(route => <Route path={route} component={routes[route]} />) }
  </Route>
);
