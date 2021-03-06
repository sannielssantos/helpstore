 unit Cargas_Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ActnList, dxBarDBNav, dxBar, dxCntner, dxEditor,
  dxEdLib, dxDBELib, StdCtrls, Db, IBCustomDataSet, dxDBEdtr, dxExEdtr,
  Buttons,   cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSharp, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, Menus, dxSkinsdxBarPainter,
  cxClasses, cxButtons, cxPC, cxLabel;

type
  TFrmCargas = class(TForm)
    pnlClient: TPanel;
    Bevel1: TBevel;
    b2: TBevel;
    LblTitulo: TcxLabel;
    Image1: TImage;
    pnlBottom: TPanel;
    dxBarDockControl1: TdxBarDockControl;
    Panel1: TPanel;
    pc: TcxPageControl;
    dxTabSheet1: TcxTabSheet;
    Label1: TcxLabel;
    Label2: TcxLabel;
    btnMotorista: TcxButton;
    Shape1: TShape;
    Label10: TcxLabel;
    Label4: TcxLabel;
    EdCodigo: TdxDBEdit;
    cmbMotorista: TdxDBLookupEdit;
    edKmSaida: TdxDBCalcEdit;
    edPeso: TdxDBCalcEdit;
    Navigator: TdxBarDBNavigator;
    BarMgr: TdxBarManager;
    btnIncluir: TdxBarButton;
    btnExcluir: TdxBarButton;
    btnLocalizar: TdxBarButton;
    BtnSalvar: TdxBarButton;
    BtnCancelar: TdxBarButton;
    BtnListagem: TdxBarButton;
    BtnFechar: TdxBarButton;
    Actions: TActionList;
    ActIncluir: TAction;
    ActAlterar: TAction;
    ActExcluir: TAction;
    ActLocalizar: TAction;
    ActListagem: TAction;
    ActPost: TAction;
    ActCancel: TAction;
    ActFechar: TAction;
    actLookup: TAction;
    dsMotoristas: TDataSource;
    DataSource: TDataSource;
    dsVeiculos: TDataSource;
    dsRotas: TDataSource;
    Label7: TcxLabel;
    cmbVeiculo: TdxDBLookupEdit;
    btnveiculo: TcxButton;
    Label8: TcxLabel;
    cmbRota: TdxDBLookupEdit;
    btnrota: TcxButton;
    Label3: TcxLabel;
    Label5: TcxLabel;
    edVolume: TdxDBCalcEdit;
    edDtSaida: TdxDBDateEdit;
    edPlaca: TdxDBMaskEdit;
    dxBarDBNavFirst1: TdxBarDBNavButton;
    dxBarDBNavPrev1: TdxBarDBNavButton;
    dxBarDBNavNext1: TdxBarDBNavButton;
    dxBarDBNavLast1: TdxBarDBNavButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActIncluirExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure ActPostExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActListagemExecute(Sender: TObject);
    procedure ActLocalizarExecute(Sender: TObject);
    procedure EdCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pnlClientResize(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
    procedure ActFecharExecute(Sender: TObject);
    procedure actLookupExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnMotoristaClick(Sender: TObject);
    procedure btnveiculoClick(Sender: TObject);
    procedure btnrotaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCargas: TFrmCargas;

implementation

uses Cadastros_DM,
     Listagens_DM,
     Application_DM,
     Main,
     Usuarios_DM,
     Funcoes,
     Motoristas_Form, Veiculos_Form, Rotas_Form;

{$R *.DFM}

procedure TFrmCargas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  If FrmMain.MDIChildCount > 1 Then
     FrmMain.Codigo_Int := Datasource.DataSet.FieldByName('CODIGO').asInteger;
  //
  If DataSource.DataSet.Tag = 0 Then
     Datasource.Dataset.Close;
  If dsMotoristas.DataSet.Tag = 0 Then
     dsMotoristas.DataSet.Close;
  If dsVeiculos.DataSet.Tag = 0 Then
     dsVeiculos.DataSet.Close;
  If dsRotas.DataSet.Tag = 0 Then
     dsRotas.DataSet.Close;
  //
{  If DMCadastros.Tag = 0 Then
     Begin
       DMCadastros.Free;
       DMCadastros := Nil;
     End;}
  //
  Action := caFree;
  FrmCargas := Nil;
  //
  If FrmMain.MDIChildCount = 1 Then
     FrmMain.PnlClient.Visible := True;
end;

procedure TFrmCargas.ActIncluirExecute(Sender: TObject);
begin
  If DataSource.State in dsEditModes Then
     Exit;
  Try
    DataSource.DataSet.Append;
  Except
    On E:EDataBaseError Do
       Begin
         ShowMessage('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ');
         Exit;
       End
    Else
       Begin
         ShowMessage('Ocorreu um Erro n�o identificado pelo Sistema !');
         Exit;
       End;
  End;
  cmbMotorista.SetFocus;
end;

procedure TFrmCargas.ActExcluirExecute(Sender: TObject);
begin
  If MessageBox(Handle,'Tem certeza que deseja Excluir este Cliente ?',
                       'Aten��o !!!',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=IDYES Then
     DataSource.Dataset.Delete;
end;

procedure TFrmCargas.ActPostExecute(Sender: TObject);
begin
  Try
    DataSource.DataSet.Post;
    DMApp.Transaction.CommitRetaining;
  Except
    On E:EDataBaseError Do
       Begin
         ShowMessage('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ');
         Exit;
       End
    Else
       Begin
         ShowMessage('Ocorreu um Erro n�o identificado pelo Sistema !');
         Exit;
       End;
  End;
end;

procedure TFrmCargas.ActCancelExecute(Sender: TObject);
begin
  If DataSource.DataSet.State in dsEditModes Then
     DataSource.DataSet.Cancel
  Else
     BtnFechar.OnClick(BtnFechar);
end;

procedure TFrmCargas.FormShow(Sender: TObject);
begin
  IniciaComponentes ( Self as TForm );
  Try
    If Not(dsMotoristas.DataSet.Active) Then
       dsMotoristas.DataSet.Open;
    If Not(dsVeiculos.DataSet.Active) Then
       dsVeiculos.DataSet.Open;
    If Not(dsRotas.DataSet.Active) Then
       dsRotas.DataSet.Open;
    If Not(Datasource.DataSet.Active) Then
       DataSource.DataSet.Open;
    (Datasource.DataSet as TIBDataset).FetchAll;
  Except
    On E:EDataBaseError Do
       Begin
         ShowMessage('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ');
         Exit;
       End
    Else
       Begin
         ShowMessage('Ocorreu um Erro n�o identificado pelo Sistema !');
         Exit;
       End;
  End;
  //
  Datasource.AutoEdit := ActAlterar.Enabled;
  cmbMotorista.SetFocus;
end;

procedure TFrmCargas.FormCreate(Sender: TObject);
begin
  //
  ActListagem.Hint := ActListagem.Hint + LblTitulo.Caption + ' [F5]';
  // Se o Usu�rio for Supervisor
  If DMUsuarios.Direito = 'SUPERVISOR' Then
     DMApp.Verifica_Modulo(FileName(Application.ExeName), Self.Name, LblTitulo.Caption, ListaActions(Actions))
  Else If DMUsuarios.Objeto = Self.Name Then
     AtivaActions(Actions, DMUsuarios.Direito);
end;

procedure TFrmCargas.ActListagemExecute(Sender: TObject);
begin
{  //
  DMListagens := TDMListagens.Create(Self);
  DMListagens.lsGeneros;
  DMListagens.Free;
  DMListagens := Nil; }
end;

procedure TFrmCargas.ActLocalizarExecute(Sender: TObject);
begin
  DMApp.Localizar(Datasource);
end;

procedure TFrmCargas.EdCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=VK_RETURN) OR (Key=VK_DOWN) Then
     Begin
       Perform(WM_NEXTDLGCTL, 0, 0);
       If Self.ActiveControl = pc Then
          Perform(WM_NEXTDLGCTL, 0, 0);
     End;
  if (key=VK_UP) then
     Perform(WM_NEXTDLGCTL, 1, 0);
end;

procedure TFrmCargas.pnlClientResize(Sender: TObject);
begin
  b2.Width := pnlClient.Width - 17;
end;

procedure TFrmCargas.DataSourceStateChange(Sender: TObject);
begin
  If DataSource.State in dsEditModes Then
     Begin
       ActIncluir.Enabled   := False;
       ActAlterar.Enabled   := False;
       ActExcluir.Enabled   := False;
       ActLocalizar.Enabled := False;
       ActListagem.Enabled  := False;
       BtnSalvar.Enabled    := True;
       BtnCancelar.Enabled  := True;
       ActFechar.Enabled    := False;
     End
  Else
     Begin
       ActIncluir.Enabled   := ActIncluir.Tag = 1;
       ActAlterar.Enabled   := ActAlterar.Tag = 1;
       ActExcluir.Enabled   := ActExcluir.Tag = 1;
       ActLocalizar.Enabled := True;
       ActListagem.Enabled  := ActListagem.Tag = 1;
       BtnSalvar.Enabled    := False;
       BtnCancelar.Enabled  := False;
       ActFechar.Enabled    := True;
     End;
end;

procedure TFrmCargas.ActFecharExecute(Sender: TObject);
begin
  If FrmCargas.FormStyle = fsMDIChild Then
     FrmMain.opFechar.OnClick(FrmMain.opFechar)
  Else
     Close;
end;

procedure TFrmCargas.actLookupExecute(Sender: TObject);
begin
  If FrmCargas.ActiveControl = cmbMotorista Then
     btnMotorista.OnClick(btnMotorista);
  If FrmCargas.ActiveControl = cmbVeiculo Then
     btnVEICULO.OnClick(btnVEICULO);
  If FrmCargas.ActiveControl = cmbRota Then
     btnRota.OnClick(btnRota);
end;

procedure TFrmCargas.FormActivate(Sender: TObject);
begin
  Try
    FrmCargas.Refresh;
    Case FrmCargas.Tag Of
         1: Begin
              //
              Datasource.DataSet.FieldByName('MOTORISTA').asInteger := FrmMain.Codigo_Int;
              dsMotoristas.DataSet.Tag := 0;
              cmbMotorista.SetFocus;
            End;
         2: Begin
              //
              Datasource.DataSet.FieldByName('VEICULO').asString := FrmMain.Codigo_Str;
              dsVeiculos.DataSet.Tag := 0;
              cmbVeiculo.SetFocus;
            End;
         3: Begin
              //
              Datasource.DataSet.FieldByName('ROTA').asInteger := FrmMain.Codigo_Int;
              dsRotas.DataSet.Tag := 0;
              cmbRota.SetFocus;
            End;
    End;
    FrmCargas.Tag := 0;
  Except
  End;
end;

procedure TFrmCargas.FormResize(Sender: TObject);
begin
  //
  pc.Height := FrmCargas.Height - 106;
  pc.Width  := FrmCargas.Width  -  25;
end;

procedure TFrmCargas.btnMotoristaClick(Sender: TObject);
begin
  //
  If ActAlterar.Tag = 0 Then
     Exit;
  //
  If Datasource.DataSet.State = dsBrowse Then
     Datasource.DataSet.Edit;
  //
  { * * * * * }
  DMApp.Verificar_Login(FileName(Application.ExeName), 'FrmMotoristas', False);
  { * * * * * }
  //
  FrmCargas.Tag            := 1;
  dsMotoristas.DataSet.Tag := 1;
  Datasource.DataSet.Tag   := 1;
  DMCadastros.Tag          := 1;
  //
  FrmMotoristas := TFrmMotoristas.Create(Self);
  //
  FrmMotoristas.Showmodal ;
  //
  Datasource.DataSet.FieldByName('MOTORISTA').asInteger := FrmMain.Codigo_Int;

  FrmCargas.Tag            := 0;
  dsMotoristas.DataSet.Tag := 0;
  Datasource.DataSet.Tag   := 0;
  DMCadastros.Tag          := 0;

end;

procedure TFrmCargas.btnveiculoClick(Sender: TObject);
begin
  //
  If ActAlterar.Tag = 0 Then
     Exit;
  //
  If Datasource.DataSet.State = dsBrowse Then
     Datasource.DataSet.Edit;
  //
  { * * * * * }
  DMApp.Verificar_Login(FileName(Application.ExeName), 'FrmVeiculos', False);
  { * * * * * }
  //
  FrmCargas.Tag          := 1;
  dsVeiculos.DataSet.Tag := 1;
  DMCadastros.Tag        := 1;
  Datasource.DataSet.Tag := 1;

  //
  FrmVeiculos := TFrmVeiculos.Create(Self);
  //
  FrmVeiculos.Showmodal ;

  Datasource.DataSet.FieldByName('VEICULO').asString := FrmMain.Codigo_Str;

  FrmCargas.Tag            := 0;
  dsVeiculos.DataSet.Tag    := 0;
  Datasource.DataSet.Tag   := 0;
  DMCadastros.Tag          := 0;
end;

procedure TFrmCargas.btnrotaClick(Sender: TObject);
begin
  //
  If ActAlterar.Tag = 0 Then
     Exit;
  //
  If Datasource.DataSet.State = dsBrowse Then
     Datasource.DataSet.Edit;
  //
  { * * * * * }
  DMApp.Verificar_Login(FileName(Application.ExeName), 'FrmRotas', False);
  { * * * * * }
  //
  FrmCargas.Tag       := 1;
  dsRotas.DataSet.Tag := 1;
  DMCadastros.Tag     := 1;
  Datasource.DataSet.Tag := 1;
  //
  FrmRotas := TFrmRotas.Create(Self);
  //
  FrmRotas.Showmodal ;

  Datasource.DataSet.FieldByName('ROTA').asInteger := FrmMain.Codigo_Int;

  FrmCargas.Tag            := 0;
  dsRotas.DataSet.Tag      := 0;
  Datasource.DataSet.Tag   := 0;
  DMCadastros.Tag          := 0;
end;

end.
