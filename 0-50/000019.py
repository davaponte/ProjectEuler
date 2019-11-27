YearStart = 1900
YearStop = 2001
DaysCount = 0
DaysMonthCount = 1
DayOfWeek = 1
MonthCount = 0
Acum = 0
#         E   F   M   A   My  Jn  Jl  Ag  S   O   N   D
Months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
Days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thusrday', 'Friday', 'Saturday']
IsLeap = False

for y in range(YearStart, YearStop):
    IsLeap = ((y % 4 == 0) and (y % 100 != 0)) or ((y % 100 == 0) and (y % 400 == 0))
    ##print('Year ', y, ' is leap: ', IsLeap)
    if IsLeap:
        Months[1] = 29
    else:
        Months[1] = 28
    for d in range(366 if IsLeap else 365):
        ##print('Year: ', y, ' Month: ', MonthCount + 1, ' #Day: ', d + 1, '#Day of month: ' , DaysMonthCount, ' Day of week: ', Days[DayOfWeek])
        
        if (y > 1900) and (DayOfWeek == 0) and (DaysMonthCount == 1):
            Acum += 1
            ##print('*' * 30)
        
        DaysMonthCount += 1
        DayOfWeek += 1
        if (DayOfWeek == 7):
            DayOfWeek = 0
        if (DaysMonthCount > Months[MonthCount]):
            DaysMonthCount = 1
            MonthCount += 1
            if (MonthCount == len(Months)):
                MonthCount = 0
        
    
print('Total: ', Acum)
