defmodule CklistWeb.PageControllerTest do
  use CklistWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Check that list"
  end

  describe "about page" do
    test "contains current app version", %{conn: conn} do
      conn = get(conn, ~p"/about")
      assert html_response(conn, 200) =~ "cklist version #{Application.spec(:cklist, :vsn)}"
    end

    test "contains phx version", %{conn: conn} do
      conn = get(conn, ~p"/about")
      assert html_response(conn, 200) =~ "phoenix #{Application.spec(:phoenix, :vsn)}"
    end

    test "renders faq", %{conn: conn} do
      conn = get(conn, ~p"/about")
      assert html_response(conn, 200) =~ "FAQ"
    end
  end

  test "privacy policy", %{conn: conn} do
    conn = get(conn, ~p"/privacy")
    assert html_response(conn, 200) =~ "We value your privacy."
  end
end
