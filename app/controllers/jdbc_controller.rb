java_import 'org.apache.hive.jdbc.HiveDriver'
java_import 'java.sql.Types'
class JdbcController < ApplicationController
  def get_data
    
    return render :text => 'Please provide sql param' unless  params['sql']

    sql = params['sql']

    # TODO: move this to configuration
    url = 'jdbc:hive2://impala-server:21050/default;auth=noSasl'
    conn = java.sql.DriverManager.get_connection(url, "dobby","")

    statement = conn.create_statement
    rs = statement.execute_query( sql )
    result = to_google_data(rs)

    render :json => result.to_json

  end

  # TODO: Move this somewhere better
  def to_google_data(result_set)
    col_md = result_set.getMetaData()
    col_count = col_md.getColumnCount()

    cols=[]
    col_count.times do |i|
      i += 1 # columns are 1-based

      col_type = col_md.getColumnType(i)
      decoded_type = decode_type(col_type)
      col = {
        :id => col_md.getColumnName(i),
        :type => decoded_type,
        :label => col_md.getColumnLabel(i)
      }
      cols << col
    end

    rows = []
    while result_set.next do
      row = [] 
      col_count.times do |i|
        col_type = cols[i][:type]
        i += 1 # columns are 1-based
        # TODO: some data conversion if needed
        row << { :v => result_set.getObject(i) }
      end
      rows << { :c => row }
    end

    ret = {
      :cols => cols,
      :rows => rows
    }

  end


  def decode_type(col_type)
    the_type = nil
    case col_type
    when Types::BIGINT, Types::INTEGER, Types::SMALLINT, Types::TINYINT, Types::DOUBLE, Types::FLOAT, Types::REAL 
      the_type='number'
    when Types::CHAR, Types::VARCHAR, Types::LONGVARCHAR
      the_type='string'
    when Types::DATE 
      the_type = 'date'
    end
    the_type
  end

    def get_columns(result)

    cols = result.getMetaData()
    result = []
    cols.getColumnCount().times do |i|
      i += 1 # columns are 1-based
      col = {
        :name => cols.getColumnName(i),
        :type => cols.getColumnType(i),
        :label => cols.getColumnLabel(i)
        # ... more stuff is available
      }
      result << col
    end
    result
  end


end
