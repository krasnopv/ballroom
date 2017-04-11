import React from 'react';
import cloneDeep from 'lodash/cloneDeep';
import findIndex from 'lodash/findIndex';
import * as Table from 'reactabular-table';
import * as dnd from 'reactabular-dnd';
import * as resolve from 'table-resolver';
import style from '../style.css';

export default class DragAndDropTable extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      columns: [
        {
          property: 'order_number',
          props: {
            label: 'Number',
            style: {
              width: 100
            }
          },
          header: {
            label: 'Number'
          }
        },
        {
          property: 'style',
          props: {
            style: {
              width: 300
            }
          },
          header: {
            label: 'Style',
          }
        },
        {
          property: 'level',
          props: {
            style: {
              width: 300
            }
          },
          header: {
            label: 'Level',
          }
        },
        {
          property: 'title',
          props: {
            style: {
              width: 300
            }
          },
          header: {
            label: 'Dance',
          }
        },
        {
          property: 'round',
          props: {
            style: {
              width: 100
            }
          },
          header: {
            label: 'Round',
          }
        },
        {
          cell: {
            formatters: [
              (value, { rowData }) => (
                <span
                  onClick={() => this.onRemove(rowData.id)} style={{ cursor: 'pointer' }}
                >
                  &#10007;
                </span>
              )
            ]
          },
          props: {
            style: {
              width: 100
            }
          }
        }
      ],
      rows: []
    };


    this.onRow = this.onRow.bind(this);
    this.onMoveRow = this.onMoveRow.bind(this);
  }

  componentDidMount() {
    fetch("/api/schedule/")
      .then(response => response.json())
      .then(json => {
        this.setState({rows: json})
      })
      .catch(err => alert(err))
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
    const { columns, rows } = this.state;
    for (let i = 0; i < rows.length; i++) {
        rows[i].order_number = (i + 1);
    }
    //const resolvedColumns = resolve.columnChildren({ columns });
    const resolvedRows = resolve.resolve({
      columns: columns,
      method: resolve.nested
    })(rows);

    return (
      <Table.Provider
        components={components}
        columns={columns}
        className={style.tableWrapper}
      >
        <Table.Header
          headerRows={resolve.headerRows({ columns })}
          className={style.tableHeader}
        />

        <Table.Body
          className={style.tableBody}
          rows={resolvedRows}
          rowKey="id"
          onRow={this.onRow}
        />
      </Table.Provider>
    );
  }

  onRow(row) {
    return {
      rowId: row.id,
      onMove: this.onMoveRow
    };
  }

  onMoveRow({ sourceRowId, targetRowId }) {
    const rows = dnd.moveRows({
      sourceRowId,
      targetRowId
    })(this.state.rows);

    if (rows) {
      this.setState({ rows });
    }
  }

  onRemove(id) {
    const rows = cloneDeep(this.state.rows);
    const idx = findIndex(rows, { id });

    // this could go through flux etc.
    rows.splice(idx, 1);

    this.setState({ rows });
  }
}