defmodule CklistWeb.ChecklistControllerTest do
  use CklistWeb.ConnCase

  import Cklist.ChecklistsFixtures
  import Cklist.AccountsFixtures

  @create_attrs %{description: "some description", title: "some title", document: %{}}
  @update_attrs %{
    description: "some updated description",
    title: "some updated title",
    document: %{}
  }
  @invalid_attrs %{description: nil, title: nil, document: nil}

  @remember_me_cookie "_cklist_web_user_remember_me"

  setup %{conn: conn} do
    user_token = Cklist.Accounts.generate_user_session_token(user_fixture())

    %{
      conn:
        conn
        |> init_test_session(%{})
        |> put_session(:user_token, user_token)
        |> put_req_cookie(@remember_me_cookie, user_token)
    }
  end

  describe "index" do
    test "lists all checklists", %{conn: conn} do
      conn = get(conn, ~p"/checklists")
      assert html_response(conn, 200) =~ "Listing Checklists"
    end
  end

  describe "new checklist" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/checklists/new")
      assert html_response(conn, 200) =~ "New Checklist"
    end
  end

  describe "create checklist" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/checklists", checklist: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/checklists/#{id}"

      conn = get(conn, ~p"/checklists/#{id}")
      assert html_response(conn, 200) =~ "Checklist #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/checklists", checklist: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Checklist"
    end
  end

  describe "edit checklist" do
    setup [:create_checklist]

    test "renders form for editing chosen checklist", %{conn: conn, checklist: checklist} do
      conn = get(conn, ~p"/checklists/#{checklist}/edit")
      assert html_response(conn, 200) =~ "Edit Checklist"
    end
  end

  describe "update checklist" do
    setup [:create_checklist]

    test "redirects when data is valid", %{conn: conn, checklist: checklist} do
      conn = put(conn, ~p"/checklists/#{checklist}", checklist: @update_attrs)
      assert redirected_to(conn) == ~p"/checklists/#{checklist}"

      conn = get(conn, ~p"/checklists/#{checklist}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, checklist: checklist} do
      conn = put(conn, ~p"/checklists/#{checklist}", checklist: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Checklist"
    end
  end

  describe "delete checklist" do
    setup [:create_checklist]

    test "deletes chosen checklist", %{conn: conn, checklist: checklist} do
      conn = delete(conn, ~p"/checklists/#{checklist}")
      assert redirected_to(conn) == ~p"/checklists"

      assert_error_sent 404, fn ->
        get(conn, ~p"/checklists/#{checklist}")
      end
    end
  end

  defp create_checklist(_) do
    checklist = checklist_fixture()
    %{checklist: checklist}
  end
end
