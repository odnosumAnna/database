-- 7. �������� ������� ��� ���, �� ������� ����� ������� ����:

CREATE PROCEDURE dbo.DeleteAccidentsBeforeDate
(
    @Date DATE
)
AS
BEGIN
    -- �������� ��������� ������ ������ � ������� Vehicle
    DELETE FROM Vehicle
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- ���� ��������� ������ ������ � ������� Driver_Involvement
    DELETE FROM Driver_Involvement
    WHERE ID_Accident IN (SELECT ID_Accident FROM Accident WHERE Date < @Date);

    -- ����� ��������� ������ � ������� Accident
    DELETE FROM Accident
    WHERE Date < @Date;
END;