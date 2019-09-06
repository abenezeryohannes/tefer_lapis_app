@extends('layouts.app')

@section('content')
    <div class="row justify-content-center">
        <div class="col-md-8">


                <div class="col-sm-6">
						<a href="#addRequestModal" class="btn btn-success" data-toggle="modal"><i class="material-icons">&#xE147;</i> <span>Add New Request</span></a>
						</div>

 <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>Organization</th>
                        <th>Work Area</th>
                        <th>Number of Days</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Approved</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>

                @foreach($internships as $intern)


                    <tr><td>{{$intern->Organization->name}}</td>
                        <td>{{$intern->work_area}}</td>
                        <td>{{$intern->number_of_days}}</td>
                        <td>{{$intern->start_date}}</td>
                        <td>{{$intern->end_date}}</td>
                        <td>@if($intern->approved_by_organization) Success @else Pending @endif</td>
                        <td>
                            <a href="#deleteInternshipModal" class="delete" data-toggle="modal"><i class="material-icons" data-toggle="tooltip" title="Delete">&#xE872;</i></a>
                        </td>
                    </tr>

                    
                @endforeach
                    
                </tbody>
            </table>

    </div>
</div>



<!-- Edit Modal HTML -->
	<div id="addRequestModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form>
					<div class="modal-header">						
						<h4 class="modal-title">Add Request</h4>
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">					
						<div class="form-group">
							<label>Organization</label>
							<input type="text" class="form-control" required>
						</div>
						<div class="form-group">
							<label>Work Area</label>
							<input type="email" class="form-control" required>
						</div>
                        <div class="form-group">
							<label>Text</label>
							<textarea class="form-control" required></textarea>
						</div>
						<div class="form-group">
							<label>Attachments (optional)</label>
							<input type='file' class="form-control"></textarea>
						</div>				
					</div>
					<div class="modal-footer">
						<input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
						<input type="submit" class="btn btn-success" value="Add">
					</div>
				</form>
			</div>
		</div>
	</div>





	<!-- Delete Modal HTML -->
	<div id="deleteInternshipModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<form>
					<div class="modal-header">						
						<h4 class="modal-title">Delete Request</h4>
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">					
						<p>Are you sure you want to delete these Records?</p>
						<p class="text-warning"><small>This action cannot be undone.</small></p>
					</div>
					<div class="modal-footer">
						<input type="button" class="btn btn-default" data-dismiss="modal" value="Cancel">
						<input type="submit" class="btn btn-danger" value="Delete">
					</div>
				</form>
			</div>
		</div>
	</div>














@endsection
