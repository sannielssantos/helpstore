 unit CaixaSaidas_Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ActnList, dxBarDBNav, dxBar, dxCntner, dxEditor,
  dxEdLib, dxDBELib, StdCtrls, Db, IBCustomDataSet, dxExEdtr, dxTL,
  dxDBCtrl, dxDBGrid, Buttons, DBCtrls, dxDBEdtr, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, Menus, dxSkinsdxBarPainter,
  cxClasses, cxButtons, cxLabel;

type
  TFrmCaixaSaidas = class(TForm)
    pnlClient: TPanel;
    pnlBottom: TPanel;
    dxBarDockControl1: TdxBarDockControl;
    BarDBNavigator: TdxBarDBNavigator;
    BarManager: TdxBarManager;
    btnIncluir: TdxBarButton;
    btnExcluir: TdxBarButton;
    dxBarBDBNavFirst: TdxBarDBNavButton;
    dxBarBDBNavPrev: TdxBarDBNavButton;
    dxBarBDBNavNext: TdxBarDBNavButton;
    dxBarBDBNavLast: TdxBarDBNavButton;
    btnLocalizar: TdxBarButton;
    BtnSalvar: TdxBarButton;
    BtnCancelar: TdxBarButton;
    Actions: TActionList;
    ActIncluir: TAction;
    ActAlterar: TAction;
    ActExcluir: TAction;
    ActLocalizar: TAction;
    ActPost: TAction;
    ActCancel: TAction;
    Bevel1: TBevel;
    Label2: TcxLabel;
    EdInicial: TdxDBEdit;
    b2: TBevel;
    LblTitulo: TcxLabel;
    DataSource: TDataSource;
    BtnListagem: TdxBarButton;
    ActListagem: TAction;
    BtnFechar: TdxBarButton;
    Panel1: TPanel;
    ActFechar: TAction;
    LblCaixa: TcxLabel;
    Label1: TcxLabel;
    dxDBEdit1: TdxDBEdit;
    Label8: TcxLabel;
    EdValor: TdxDBCalcEdit;
    GRID: TdxDBGrid;
    GRIDDOCUMENTO: TdxDBGridMaskColumn;
    GRIDHISTORICO: TdxDBGridMaskColumn;
    GRIDVALOR: TdxDBGridMaskColumn;
    Label9: TcxLabel;
    CmbTipo: TdxDBPickEdit;
    GRIDColumn4: TdxDBGridColumn;
    Label5: TcxLabel;
    CMBpessoa: TdxDBButtonEdit;
    BtnPessoa: TcxButton;
    dxDBEdit4: TdxDBEdit;
    ActLookUp: TAction;
    Label7: TcxLabel;
    EdCredito: TdxDBButtonEdit;
    DBText1: TDBText;
    opAlterar: TdxBarButton;
    BtnCentro: TcxButton;
    cmbcentro: TdxDBLookupEdit;
    Label3: TcxLabel;
    DsCentro: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActIncluirExecute(Sender: TObject);
    procedure ActExcluirExecute(Sender: TObject);
    procedure ActPostExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActLocalizarExecute(Sender: TObject);
    procedure dxDBEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure pnlClientResize(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
    procedure ActFecharExecute(Sender: TObject);
    procedure EdInicialEnter(Sender: TObject);
    procedure EdInicialExit(Sender: TObject);
    procedure CMBpessoaButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure ActLookUpExecute(Sender: TObject);
    procedure BtnPessoaClick(Sender: TObject);
    procedure EdCreditoButtonClick(Sender: TObject;
      AbsoluteIndex: Integer);
    procedure ActAlterarExecute(Sender: TObject);
    procedure BtnCentroClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Retorno: Integer;
  end;

var
  FrmCaixaSaidas: TFrmCaixaSaidas;

implementation

uses Caixa_DM,
     Listagens_DM,
     Application_DM,
     Main,
     Usuarios_DM,
     Funcoes,
     Localizar_Cliente,
     Cadastros_DM,
     Localizar_Conta, Plano_DM, Financeiro_Dm,
  Centro_Custo_Form, untCadClientes;

{$R *.DFM}

procedure TFrmCaixaSaidas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     If MessageDlg('Sair da Tela', mtConfirmation, [mbOK, mbCancel], 0) = MrOk
     then begin
          //
          If Datasource.DataSet.Tag = 0 Then
          Datasource.Dataset.Close;

          Frm_Localizar_Cliente.Free ;
          Frm_Localizar_Cliente := Nil ;

          //
          If DMCaixa.Tag = 0
          Then Begin
               DMCaixa.Free;
               DMCaixa := Nil;
          End;

          dmApp.ZeraCaixaUsuario(owner);

          If FrmCaixaSaidas.FormStyle = fsMDIChild Then
            FrmMain.PnlClient.Visible := True;

          //
          Action := caFree;
          FrmCaixaSaidas := Nil;
     end
     else begin
          Action := CaNone ;
     end;
end;

procedure TFrmCaixaSaidas.ActIncluirExecute(Sender: TObject);
begin
  If DataSource.State in dsEditModes Then
     Exit;
  Try
    DataSource.DataSet.Append;
  Except
    On E:EDataBaseError Do
       Begin
         MessageDlg('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ',MtError,[MbOk],0);
         Exit;
       End
    Else
       Begin
         MessageDlg('Ocorreu um Erro n�o identificado pelo Sistema !',MtError,[MbOk],0);
         Exit;
       End;
  End;
  CMBpessoa.SetFocus;
end;

procedure TFrmCaixaSaidas.ActExcluirExecute(Sender: TObject);
begin
  If MessageBox(Handle,'Tem certeza que deseja Excluir este G�nero ?',
                       'Aten��o !!!',MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=IDYES Then
     DataSource.Dataset.Delete;
end;

procedure TFrmCaixaSaidas.ActPostExecute(Sender: TObject);
begin
  Try
    DataSource.DataSet.Post;
    DMApp.Transaction.CommitRetaining;
  Except
    On E:EDataBaseError Do
       Begin
         MessageDlg('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ',MtError,[MbOk],0);
         Exit;
       End
    Else
       Begin
         MessageDlg('Ocorreu um Erro n�o identificado pelo Sistema !',MtError,[MbOk],0);
         Exit;
       End;
  End;
end;

procedure TFrmCaixaSaidas.ActCancelExecute(Sender: TObject);
begin
  If DataSource.DataSet.State in dsEditModes Then
     DataSource.DataSet.Cancel
  Else
     BtnFechar.OnClick(BtnFechar);
end;

procedure TFrmCaixaSaidas.FormShow(Sender: TObject);
begin
  IniciaComponentes ( Self as TForm );
  //
  Try
    If Not(DataSource.DataSet.Active) Then
       Datasource.DataSet.Open;

    (Datasource.DataSet as TIBDataset).FetchAll;

    //Cria o Formulario de Localizar Cliente
    Application.CreateForm(TFrm_Localizar_Cliente, Frm_Localizar_Cliente) ;

  Except
    On E:EDataBaseError Do
       Begin
         MessageDlg('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ',MtError,[MbOk],0);
         Exit;
       End
    Else
       Begin
         MessageDlg('Ocorreu um Erro n�o identificado pelo Sistema !',MtError,[MbOk],0);
         Exit;
       End;
  End;

  EdInicial.SetFocus;
  DmFinanceiro.SelCentro.Close;
  DmFinanceiro.SelCentro.Open;
end;

procedure TFrmCaixaSaidas.FormCreate(Sender: TObject);
begin
  //
  ActListagem.Hint := ActListagem.Hint + LblTitulo.Caption + ' [F5]';

  // Se o Usu�rio for Supervisor
  If DMUsuarios.Direito = 'SUPERVISOR' Then
     DMApp.Verifica_Modulo(FileName(Application.ExeName), Self.Name, LblTitulo.Caption, ListaActions(Actions))
  Else If DMUsuarios.Objeto = Self.Name Then
     AtivaActions(Actions, DMUsuarios.Direito);
end;

procedure TFrmCaixaSaidas.ActLocalizarExecute(Sender: TObject);
begin
  DMApp.Localizar(Datasource);
end;

procedure TFrmCaixaSaidas.dxDBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_RETURN) OR (Key=VK_DOWN) Then
     Perform(WM_NEXTDLGCTL, 0, 0);
  if (key=VK_UP) then
     Perform(WM_NEXTDLGCTL, 1, 0);
end;

procedure TFrmCaixaSaidas.pnlClientResize(Sender: TObject);
begin
  b2.Width := pnlClient.Width - 17;
end;

procedure TFrmCaixaSaidas.DataSourceStateChange(Sender: TObject);
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

procedure TFrmCaixaSaidas.ActFecharExecute(Sender: TObject);
begin
  If FrmCaixaSaidas.FormStyle = fsMDIChild Then
     FrmMain.opFechar.OnClick(FrmMain.opFechar)
  Else
     Close;
end;

procedure TFrmCaixaSaidas.EdInicialEnter(Sender: TObject);
begin
     CORFUNDO ( SENDER );
end;

procedure TFrmCaixaSaidas.EdInicialExit(Sender: TObject);
begin
     TIRACORFUNDO ( SENDER );
end;

procedure TFrmCaixaSaidas.CMBpessoaButtonClick(Sender: TObject; AbsoluteIndex: Integer);
begin
     try
        If Not ( DataSource.State in [ dsinsert, dsedit ] )
        Then begin
             DataSource.DataSet.Edit ;
        end;

        //Chama a Tela Para Localizar Cliente
        Frm_Localizar_Cliente.DSource.dataset := DmCaixa.SelPessoasFJ ;

        if ( Frm_Localizar_Cliente.showmodal = mrOk )
        Then Begin
             DmCaixa.MovimentosPESSOA_FJ.Value := (Frm_Localizar_Cliente.CampTrecho) ;
        end;

     Except
     end;
end;

procedure TFrmCaixaSaidas.ActLookUpExecute(Sender: TObject);
begin
     If FrmCaixaSaidas.ActiveControl = CMBpessoa Then
       BtnPessoa.OnClick(BtnPessoa)
     else If FrmCaixaSaidas.ActiveControl = cmbcentro Then
       BtnCentro.OnClick(BtnCentro);
end;

procedure TFrmCaixaSaidas.BtnPessoaClick(Sender: TObject);
begin
  If Datasource.DataSet.State = dsBrowse Then
    Datasource.DataSet.Edit;

    DMApp.Verificar_Login(FileName(Application.ExeName), 'frmCadClientes', False);
    if frmCadClientes = Nil Then
    begin
       frmCadClientes := TfrmCadClientes.Create(Self);
       frmCadClientes.ShowMODAL ;
       Datasource.DataSet.FieldByName('PESSOA_FJ').asInteger := frmCadClientes.Codigo;
       frmCadClientes.Free      ;
       frmCadClientes := Nil    ;
    end;
{DMApp.Verificar_Login(FileName(Application.ExeName), 'FrmClientes', False);
  FrmClientes := TFrmClientes.Create(Application);
  FrmClientes.Showmodal ;
  Datasource.DataSet.FieldByName('PESSOA_FJ').asInteger := FrmMain.Codigo_Int;  }

  cmbPessoa.SetFocus;
end;

procedure TFrmCaixaSaidas.EdCreditoButtonClick(Sender: TObject;
  AbsoluteIndex: Integer);
Var
   Aux: Integer;
begin
  if not (Self.DataSOURCE.State in [ dsinsert, dsedit ]) then
    DmCaixa.Movimentos.Edit;

  Application.CreateForm(TFrm_Localizar_Conta, Frm_Localizar_Conta);
  if dmPlano = nil then
    dmPlano := TdmPlano.Create(nil);

  if (Frm_Localizar_Conta.showmodal = mrOK) then
  begin
    Aux := Frm_Localizar_Conta.CampTrecho ;
    DmCaixa.MovimentosCONTRA_PARTIDA.VALUE := Aux;
  end;

  Frm_Localizar_Conta.free ;
  Frm_Localizar_Conta := Nil ;
end;

procedure TFrmCaixaSaidas.ActAlterarExecute(Sender: TObject);
begin
  If DataSource.State in dsEditModes Then
     Exit;
  Try
    DataSource.DataSet.Edit;
  Except
    On E:EDataBaseError Do
       Begin
         MessageDlg('Ocorreu o seguinte erro :' + #13 + #13 + '    ' + E.Message + '...   ',MtError,[MbOk],0);
         Exit;
       End
    Else
       Begin
         MessageDlg('Ocorreu um Erro n�o identificado pelo Sistema !',MtError,[MbOk],0);
         Exit;
       End;
  End;
end;

procedure TFrmCaixaSaidas.BtnCentroClick(Sender: TObject);
begin
  //
  If ActAlterar.Tag = 0 Then
     Exit;
  //
  If Datasource.DataSet.State = dsBrowse Then
     Datasource.DataSet.Edit;

  DMApp.Verificar_Login(FileName(Application.ExeName), 'FrmCCusto', False);
  FrmCCusto := TFrmCCusto.Create(Self);
  FrmCCusto.ShowModal;
  Datasource.DataSet.FieldByName('CENTRO_CUSTO').asInteger := FrmMain.Codigo_Int;
  FrmCCusto.Free;
  FrmCCusto := Nil;

  dsCentro.DataSet.Close ;
  dsCentro.DataSet.Open  ;
  cmbCentro.SetFocus;
end;

end.
