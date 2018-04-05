package body MinPkg is

   protected body Min is

      entry Set (val: Integer) when busy = false is
      begin
         busy := true;
         if val < min then
            min := val;
         end if;
      end;

      procedure Release is
      begin
         busy := false;
      end;

      function GetMin return Integer is
      begin
         return Min;
      end;

   end Min;
end MinPkg;
