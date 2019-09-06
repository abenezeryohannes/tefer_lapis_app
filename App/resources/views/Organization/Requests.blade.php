@extends('layouts.app')

@section('content')
    <div class="row justify-content-center">
        <div class="col-md-8">

 <table class="table table-striped table-hover">
                <thead>
                    <tr>
						
                        <th>Name</th>
                        <th>Department</th>
                        <th>Work Area</th>
                        <th>Grade</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Attachment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>

                @foreach ($internships as $intern)
                
                    <tr>	
                        <td>{{$intern->student->user->name}}</td>
                        <td>{{App\User::find($intern->student->department_id)->name}}</td>
                        <td>{{$intern->work_area}}</td>
                        <td>{{$intern->student->user->phone_number}}</td>
                        <td>{{$intern->student->user->email}}</td>
                        <td>{{$intern->student->user->phone_number}}</td>
                        <td> none </td>
                        <td>
                            <a href="#deleteEmployeeModal" class="delete" data-toggle="modal"><i class="material-icons" data-toggle="tooltip" title="Delete">&#xE872;</i></a>
                        </td>
                    </tr>

                @endforeach
                    
                </tbody>
            </table>



		</div>
	</div>





@endsection
