defmodule CklistWeb.PageControllerTest do
  use CklistWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind"
  end
end
