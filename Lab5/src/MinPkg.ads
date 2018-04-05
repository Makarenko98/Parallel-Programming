package MinPkg is

  protected type Min is

      entry Set (val: Integer);
      procedure Release;
      function GetMin return Integer;

  private
      busy : Boolean := false;
      min: Integer :=  32000;

  end;
end MinPkg;
