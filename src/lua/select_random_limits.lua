#!/usr/bin/env sysbench

require("oltp_common")

-- Override standard prepare/cleanup OLTP functions, as this benchmark does not
-- support multiple tables
oltp_prepare = prepare
oltp_cleanup = cleanup

function prepare()
   assert(sysbench.opt.tables == 1, "this benchmark does not support " ..
             "--tables > 1")
   oltp_prepare()
end

function cleanup()
   assert(sysbench.opt.tables == 1, "this benchmark does not support " ..
             "--tables > 1")
   oltp_cleanup()
end

function thread_init()
   drv = sysbench.sql.driver()
   con = drv:connect()

   local limit = "10"

   stmt = con:prepare(string.format([[
        SELECT *
          FROM sbtest1
          LIMIT %s]], limit))

   rlen = sysbench.opt.table_size / sysbench.opt.threads

   thread_id = sysbench.tid % sysbench.opt.threads
end

function thread_done()
   stmt:close()
   con:disconnect()
end

function event()
   stmt:execute()

   check_reconnect()
end
