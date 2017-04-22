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
import CompetitorsList      from '../PageCompetitorList.jsx'
import EditProfile          from '../PageEditProfile.jsx'
import EnterCallbacks       from '../PageEnterCallbacks.jsx'
import EditCompetition      from '../PageEditCompetition.jsx'

const routes = {
  'home'                                                       : HomePage,
  'competition/:competition_id/eventregistration'              : EventRegistration,
  'competition/:competition_id/editschedule'                   : EditSchedule,
  'competition/:competition_id/run'                            : RunCompetition,
  'competition/:competition_id/competitorslist'                : CompetitorsList,
  'competition/:competition_id/:competitor_id'                 : CompetitionPage,
  'competitions'                                               : CompetitionListPage,
  'admin/competition/:competition_id'                          : CompetitionHomeAdmin,
  'editprofile'                                                : EditProfile,
  'competition/:competition_id/round/:round_id/entercallbacks' : EnterCallbacks,
  'editcompetition/:competition_id'                            : EditCompetition,
}

export default (
  <Route path="/" component={App}>
    <IndexRoute component={LoginPage} />
    { Object.keys(routes)
      .map((route, i) => <Route key={i} path={route} component={routes[route]} />) }
  </Route>
);
