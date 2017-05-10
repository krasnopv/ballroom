import React from 'react';
import cloneDeep from 'lodash/cloneDeep';
import findIndex from 'lodash/findIndex';
import * as Table from 'reactabular-table';
import * as dnd from 'reactabular-dnd';
import * as resolve from 'table-resolver';
import * as search from 'searchtabular';
import style from '../style.css';
import { browserHistory, Link } from 'react-router';
import { compose } from 'redux';


export default class CompetitorList extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      query: {},
      sortingColumns: {},
      columns: [
        {
            id: 'name',
            property: 'name',
            props: {
                style: {
                    width: 250
                }
            },
            header: {
                label: 'Name',
            }
        },
        {
          id: 'affiliationname',
          property: 'affiliationname',
          props: {
            style: {
              width: 250
            }
          },
          header: {
            label: 'Organization',
          }
        },
        {
          id: 'number',
          property: 'number',
          props: {
            style: {
              width: 150
            }
          },
          header: {
            label: 'Number',
          }
        },
        {
          id: 'amount',
          property: 'amount',
          props: {
            style: {
              width: 200
            }
          },
          header: {
            label: 'Owes',
          }
        },
        {
          id: 'paidwithaffiliation',
          property: 'paidwithaffiliation',
          props: {
            style: {
              width: 100
            }
          },
          header: {
            label: 'Paying w/ Organization?',
          }
        },
      	{
            cell: {
      		    formatters: [
                  (value, { rowData }) => (
                    <div>
                      <button
                        className={style.editBtns}
                        onClick={()=>{ browserHistory.push(`/competition/${this.props.selected.competition}/seecompetitor/${rowData.id}`) }}>
                          Edit/See More
                      </button>
      			        </div>
      		      )
      		    ]
      	    },
      		width: 100
        },
        {
          props: {
            style: {
              width: 100
            }
          }
        }
      ],
      rows: []
    };
  }

  getColumns() {
      	  return [
               {
      		    id: 'name',
      		    property: 'name',
      		    header: {
      		        label: 'Name',
      		        sortable: true,
      		        resizable: true
      		    },
      		    cell: {
      		        highlight: true
      		    },
      		    width: 250
      		 },
      		 {
      		     id: 'affiliationname',
      		     property: 'affiliationname',
      		     header: {
      		        label: 'Organization',
      		        sortable: true,
      		        resizable: true
      		    },
      		    cell: {
      		        highlight: true
      		    },
      		    width: 250
      		 },
      		 {
      		    id: 'number',
      		    property: 'number',
      		    header: {
      		        label: 'Number',
      		        sortable: true,
      		        resizable: true
      		    },
      		    cell: {
      		        highlight: true
      		    },
      		    width: 150
      		 },
      		 {
      		    id: 'amount',
      		    property: 'amount',
      		    header: {
      		        label: 'Owes',
      		        sortable: true,
      		        resizable: true
      		    },
      		    cell: {
      		        highlight: true
      		    },
      		    width: 200
      		 },
      		 {
      		     id: 'paidwithaffiliation',
      		     property: 'paidwithaffiliation',
      		     header: {
      		         label: 'Paying w/ Organization?',
      		         sortable: true,
      		         resizable: true
      		     },
      		     cell: {
      		         highlight: true
      		     },
      		     width: 100
      		 },
      		 {
      		     cell: {
      		         formatters: [
                         (value, { rowData }) => (
                          <div>
                            <button
                              className={style.editBtns}
                              onClick={()=>{ browserHistory.push(`/competition/${this.props.selected.competition}/seecompetitor/${rowData.id}`) }}>
                                Edit/See More
                            </button>
      			               </div>
      		             )
      		         ]
      		     },
      		     width: 100
      		 },
      		 ];
      		 }

  componentWillMount() {
		if (this.props.data){
			this.setState({query: this.props.data.query})
		}
  }

  componentDidMount() {
    this.props.api.get(`/api/competition/${this.props.selected.competition}/competitors`)
		  .then(json => {
        this.rows = json;
        for (let i = 0; i < this.rows.length; i++) {
              this.rows[i].amount = "$" + (this.rows[i].amount || 0);
              if (this.rows[i].paidwithaffiliation) {
                      this.rows[i].paidwithaffiliation = "Yes";
              } else {
                      this.rows[i].paidwithaffiliation = "No";
              }
		    }
		    this.setState({ rows: json, }); 
		 })
		 .catch(err => alert(err));
  }

  render() {
    const components = {
      header: {
        wrapper: 'thead',
        row: 'tr',
        cell: 'th'
      },
      body: {
        row: dnd.Row
      }
    };
    const { columns, rows, query } = this.state;
    for (let i = 0; i < rows.length; i++) {
        rows[i].order_number = (i + 1);
    }
    //const resolvedColumns = resolve.columnChildren({ columns });
    const resolvedRows = compose(
      search.multipleColumns({ columns: columns, query }),
      resolve.resolve({
		     columns: columns,
		     method: (extra) => compose(
                resolve.byFunction('cell.resolve')(extra),
                resolve.nested(extra)
            )
		 })
    )(rows);
 
    var totalOwed = 0; var totalListed = 0;
    for (let i = 0; i < resolvedRows.length; i++) {
        totalListed += 1;
        if (resolvedRows[i].amount != 0)
            totalOwed += parseFloat((resolvedRows[i].amount).substr(1));
    }  

    return (
      <div>
      <p><b>Number of competitors listed: </b>{totalListed} ------- <b>Total amount owed: </b>${totalOwed}</p>

      <Table.Provider
        components={components}
        columns={columns}
        className={style.tableWrapper}
      >
        <Table.Header
          headerRows={resolve.headerRows({ columns })}
          className={style.tableHeader}
        >
                <search.Columns
                  query={query}
                  columns={columns}
                  onChange={query => this.setState({ query })}
                />
        </Table.Header>
        <Table.Body
          className={style.tableBody}
          rows={resolvedRows}
          rowKey="id"
          onRow={this.onRow}
        />
      </Table.Provider>
      </div>
    );
  }
}
