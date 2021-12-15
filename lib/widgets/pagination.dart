import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final bool _isWaiting;
  final int _currentPage;
  final Function _onPressed;

  const Pagination(this._isWaiting, this._currentPage, this._onPressed,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isWaiting
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: _currentPage == 1
                          ? const Color(0xBBeeffff)
                          : Colors.grey[200],
                      child: TextButton(
                        child: const Text("1"),
                        onPressed: () => _onPressed(1),
                        // () => setState(() {
                        //   _currentPage = 1;
                        //   gatherNewGames();
                        // }),
                      ),
                    ),
                  ),
                  if (_currentPage - 1 > 2)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: const Center(child: Text("...")),
                      ),
                    ),
                  if (_currentPage - 1 > 1)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: TextButton(
                          child: Text((_currentPage - 1).toString()),
                          onPressed: () => _onPressed(_currentPage - 1),
                        ),
                      ),
                    ),
                  if (_currentPage != 1 && _currentPage != 302)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xBBeeffff),
                        child: TextButton(
                          child: Text(_currentPage.toString()),
                          onPressed: null,
                        ),
                      ),
                    ),
                  if (_currentPage + 1 < 302)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: TextButton(
                          child: Text((_currentPage + 1).toString()),
                          onPressed: () => _onPressed(_currentPage + 1),
                        ),
                      ),
                    ),
                  if (_currentPage + 1 < 301)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: const Center(child: Text("...")),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: _currentPage == 302
                          ? const Color(0xBBeeffff)
                          : Colors.grey[200],
                      child: TextButton(
                        child: const Text("302"),
                        onPressed: () => _onPressed(302),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
